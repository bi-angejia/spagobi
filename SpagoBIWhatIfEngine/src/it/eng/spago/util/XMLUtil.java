package it.eng.spago.util;

import it.eng.spago.base.SourceBean;
import it.eng.spago.base.XMLObject;
import it.eng.spago.configuration.ConfigSingleton;
import it.eng.spago.configuration.IConfigurationCreator;
import it.eng.spago.tracing.TracerSingleton;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.util.List;
import java.util.Vector;
import org.apache.xerces.dom.DocumentImpl;
import org.apache.xerces.dom.DocumentTypeImpl;
import org.apache.xml.serialize.OutputFormat;
import org.w3c.dom.Document;

public abstract class XMLUtil
{
  public static final String XML_MAPPINGS = "XML_MAPPINGS.MAPPING";
  public static final String REPLACING = "REPLACING";
  public static final String REPLACED = "REPLACED";
  public static final String XML_HEADER_PREFIX = "<?xml";
  public static final String XML_HEADER_DEFAULT_VERSION = "1.0";
  public static final String XML_HEADER_DEFAULT_ENCODING = "UTF-8";
  public static final String XML_HEADER_DEFAULT_DOCTYPE = "/WEB-INF/conf/spago/xhtml-lat1.ent";
  private static final int _xmlIdentationSpaces = 2;
  private static boolean _mappingsRetrieved = false;
  private static int _mappingsNumber = 0;
  private static Vector _replacingMappings = null;
  private static Vector _replacedMappings = null;
  private static String _doctypeDefinition = null;

  public static String getIndentation(int level) {
    StringBuffer indentationLevel = new StringBuffer();
    for (int i = 0; i < 2; i++)
      indentationLevel.append(" ");
    StringBuffer indentation = new StringBuffer();
    for (int i = 0; i < level; i++)
      indentation.append(indentationLevel);
    return indentation.toString();
  }

  public static String normalizeAttribute(String attribute) {
    if (attribute == null)
      return null;
    char[] attributeArray = attribute.toCharArray();
    StringBuffer normalizedAttribute = new StringBuffer();
    for (int i = 0; i < attributeArray.length; i++) {
      char c = attributeArray[i];
      switch (c)
      {
      case '<':
        normalizedAttribute.append("&lt;");
        break;
      case '>':
        normalizedAttribute.append("&gt;");
        break;
      case '&':
        normalizedAttribute.append("&amp;");
        break;
      case '"':
        normalizedAttribute.append("&quot;");
        break;
      default:
        normalizedAttribute.append(c);
      }
    }

    return normalizedAttribute.toString();
  }

  private static String parseAttribute(String toParse, String replacing, String replaced) {
    if (toParse == null)
      return null;
    if ((replacing == null) || (replaced == null))
      return toParse;
    StringBuffer parsed = new StringBuffer();
    int parameterIndex = toParse.indexOf(replacing);
    while (parameterIndex != -1) {
      parsed.append(toParse.substring(0, parameterIndex));
      parsed.append(replaced);
      toParse = toParse.substring(parameterIndex + replacing.length(), toParse.length());
      parameterIndex = toParse.indexOf(replacing);
    }
    parsed.append(toParse);
    return parsed.toString();
  }

  public static String parseAttribute(String attribute)
  {
    if (attribute == null)
      return null;
    String parsed = attribute;
    if (!_mappingsRetrieved) {
      synchronized (XMLUtil.class) {
        if (!_mappingsRetrieved) {
          _mappingsRetrieved = true;
          ConfigSingleton configure = ConfigSingleton.getInstance();
          List mappings = configure.getAttributeAsList("XML_MAPPINGS.MAPPING");
          if (mappings == null) {
            _mappingsNumber = 0;
            return parsed;
          }
          _mappingsNumber = mappings.size();
          _replacingMappings = new Vector();
          _replacedMappings = new Vector();
          for (int i = 0; i < _mappingsNumber; i++) {
            SourceBean mapping = (SourceBean)mappings.get(i);
            _replacingMappings.addElement(mapping.getAttribute("REPLACING"));
            _replacedMappings.addElement(mapping.getAttribute("REPLACED"));
          }
        }
      }
    }
    for (int i = 0; i < _mappingsNumber; i++)
      parsed = parseAttribute(parsed, (String)_replacingMappings.elementAt(i), (String)_replacedMappings.elementAt(i));
    return parsed;
  }

  public static String getDoctypeFilename()
  {
    String doctypeFilename = (String)ConfigSingleton.getInstance().getAttribute("COMMON.XHTML_LAT1_ENT");
    if (doctypeFilename == null) {
      TracerSingleton.log("Spago", 4, "XMLUtil::getDoctype: doctypeFilename non valido");

      doctypeFilename = "/WEB-INF/conf/spago/xhtml-lat1.ent";
    }

    return doctypeFilename;
  }

  public static String getDoctypeDefinition() {
    if (_doctypeDefinition == null)
      synchronized (XMLUtil.class) {
        if (_doctypeDefinition == null) {
          IConfigurationCreator configCreator = ConfigSingleton.getConfigurationCreator();
          StringBuffer doctypeDefinitionBuffer = new StringBuffer();
          try {
            InputStream inDoctypeFile = configCreator.getInputStream(getDoctypeFilename());
            int ch = 0;
            while ((ch = inDoctypeFile.read()) != -1) {
              doctypeDefinitionBuffer.append((char)ch);
            }
            inDoctypeFile.close();
          }
          catch (Exception ex) {
            TracerSingleton.log("Spago", 4, "XMLUtil::getDoctypeDefinition: ", ex);
          }

          _doctypeDefinition = doctypeDefinitionBuffer.toString();
        }
      }
    return _doctypeDefinition;
  }

  public static String toXML(XMLObject xmlObject, boolean inlineEntity, boolean indent, it.eng.spago.base.XMLSerializer serializer) {
    Document document = xmlObject.toDocument(serializer);
    if (document == null)
      return "";
    OutputFormat format = new OutputFormat(document);
    format.setEncoding("UTF-8");
    format.setIndenting(indent);
    format.setIndent(indent ? 2 : 0);
    format.setLineWidth(0);
    format.setLineSeparator(ConfigSingleton.LINE_SEPARATOR);
    format.setPreserveEmptyAttributes(true);
    StringWriter stringOut = new StringWriter();
    org.apache.xml.serialize.XMLSerializer serial = new org.apache.xml.serialize.XMLSerializer(stringOut, format);
    try {
      serial.asDOMSerializer();
      if (inlineEntity)
        serial.serialize(document);
      else
        serial.serialize(document.getDocumentElement());
    }
    catch (IOException ex) {
      TracerSingleton.log("Spago", 4, "XMLUtil::toXML: ", ex);
    }
    return stringOut.toString();
  }

  public static Document toDocument(XMLObject xmlObject, it.eng.spago.base.XMLSerializer serializer) {
    DocumentImpl document = new DocumentImpl();
    document.appendChild(xmlObject.toElement(document, serializer));
    DocumentTypeImpl dtd = new DocumentTypeImpl(document, "dtd");
    dtd.setInternalSubset(getDoctypeDefinition());
    document.appendChild(dtd);
    return document;
  }
}