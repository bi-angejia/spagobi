package it.eng.spagobi.commons.services;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Map;

import it.eng.spago.base.SourceBean;
import it.eng.spago.configuration.ConfigSingleton;
import it.eng.spagobi.security.LDAPConnector;
public class ConnectDataBase {
	 final public static String MYSQL_URL = "MYSQL_URL";
	 final public static String MYSQL_USER = "MYSQL_USER";
	 final public static String MYSQL_PWD = "MYSQL_PWD";
	 public Map<String, Object> getDatebase(){
		 
		 SourceBean configSingleton = (SourceBean)ConfigSingleton.getInstance();
         SourceBean config = (SourceBean)configSingleton.getAttribute("LDAP_AUTHORIZATIONS.CONFIG");
         Map<String, Object> attrbutes = new HashMap<String, Object>();
       //数据库链接部分
 		attrbutes.put("url", getAttribute(config, MYSQL_URL));
 		attrbutes.put("username", getAttribute(config,MYSQL_USER));	
 		attrbutes.put("password", getAttribute(config,MYSQL_PWD));
 		return attrbutes;
	 }
	private static String getAttribute(SourceBean config, String attributeName) {
			return ((SourceBean)config.getAttribute(attributeName)).getCharacters();
		}
	public void insert_document(String userid,String documentId){
	    String driver = "com.mysql.jdbc.Driver";
	    try { 
	     // 加载驱动程序
	     Class.forName(driver);
	     Map<String, Object> map=this.getDatebase();
	     // 连续数据库
	    
	     Connection conn = DriverManager.getConnection(map.get("url").toString(),map.get("username").toString(),map.get("password").toString());
	     if(!conn.isClosed()) 
	      System.out.println("Succeeded connecting to the Database!");

	     // statement用来执行SQL语句
	     Statement statement = conn.createStatement();
	     Timestamp timestamp = new Timestamp(System.currentTimeMillis());
	     String insertsql="INSERT into spagobi.sbi_document_open VALUES(\""+userid+"\",\""+documentId+"\",\""+timestamp+"\")";
	     statement.execute(insertsql);
	    System.out.println("sbi_document_open modify");
	     conn.close();
	   
	    } catch(Exception e) 
	    {

	     e.printStackTrace();
	    } 
	}
}
