/* SpagoBI, the Open Source Business Intelligence suite

 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. */
package it.eng.qbe.datasource.jpa.impl;

import it.eng.qbe.datasource.AbstractDataSourceTestCase;
import it.eng.qbe.datasource.DriverManager;
import it.eng.qbe.datasource.configuration.FileDataSourceConfiguration;
import it.eng.qbe.datasource.configuration.IDataSourceConfiguration;
import it.eng.qbe.datasource.jpa.JPADataSource;
import it.eng.qbe.datasource.jpa.JPADriver;

import java.io.File;

/**
 * @author Andrea Gioia (andrea.gioia@eng.it)
 *
 */
public class StandardJPAELinkImplDataSourceTestCase extends AbstractDataSourceTestCase {
	
	
	private static final String QBE_FILE = "test-resources/jpa/jpaImpl/eclipselink/datamart.jar";
	
	@Override
	protected void setUpDataSource() {
		IDataSourceConfiguration configuration;
		
		modelName = "foodmart"; 
		
		File file = new File(QBE_FILE);
		configuration = new FileDataSourceConfiguration(modelName, file);
		configuration.loadDataSourceProperties().put("connection", connection);
		dataSource = DriverManager.getDataSource(JPADriver.DRIVER_ID, configuration);
		
		testEntityUniqueName = "it.eng.spagobi.meta.Customer::Customer";
	}
	
	
	public void testJpaElinkImpl() {
		doTests();
	}
	
	
	public void doTests() {
		super.doTests();
		
		// add custom tests here...
		doTestDataSourceImplementation();
	}
	
	// add Jpa Eclipselink Impl specific tests here ...
	
	public void doTestDataSourceImplementation() {
		assertTrue(dataSource instanceof JPADataSource);
	}
}
