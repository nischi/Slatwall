/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component extends="BaseService" accessors="true" output="false" {

	// Injected via Coldspring
	property name="integrationService" type="any";

	// Properties used for Caching values in the application scope
	property name="permissions" type="struct";
	
	// Uses the current mura user to check security against a given action
	public boolean function secureDisplay(required string action, any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = getSlatwallScope().getCurrentAccount();
		}
		
		// Check if the user is a super admin, if true no need to worry about security
		if( findNoCase("*", arguments.account.getAllPermissions()) ) {
			return true;
		}
		
		var subsystemName = listFirst( arguments.action, ":" );
		var sectionName = listFirst( listLast(arguments.action, ":"), "." );
		var itemName = listLast( arguments.action, "." );
		
		//check if the page is public, if public no need to worry about security
		if(listFindNocase(getPermissions()[ subsystemName ][ sectionName ].publicMethods, itemName)){
			return true;
		}	
		
		// Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
		if(listFindNocase(getPermissions()[ subsystemName ][ sectionName ].anyAdminMethods, itemName) && len(arguments.account.getAllPermissions())) {
			return true;
		}
		
		// Check if the acount has access to a secure method
		if( listFindNoCase(arguments.account.getAllPermissions(), replace(replace(arguments.action, ".", "", "all"), ":", "", "all")) ) {
			return true;
		}
		
		return false;
	}
	
	public struct function getPermissions(){
		if(!structKeyExists(variables, "permissions")){
			var allPermissions={
				admin={}
			};
			
			// Setup Admin Permissions
			var adminDirectoryList = directoryList( expandPath("/Slatwall/admin/controllers"), false, "path", "*.cfc" );
			for(var i=1; i <= arrayLen(adminDirectoryList); i++){
				
				var section = listFirst(listLast(adminDirectoryList[i],"/\"),".");
				var obj = createObject('component','Slatwall.admin.controllers.' & section);
				
				allPermissions.admin[ section ] = {
					publicMethods = "",
					anyAdminMethods = "",
					secureMethods = "",
					securePermissionOptions = []
				};
				
				if(structKeyExists(obj, 'publicMethods')){
					allPermissions.admin[ section ].publicMethods = obj.publicMethods;
				}
				if(structKeyExists(obj, 'anyAdminMethods')){
					allPermissions.admin[ section ].anyAdminMethods = obj.anyAdminMethods;
				}
				if(structKeyExists(obj, 'secureMethods')){	
					allPermissions.admin[ section ].secureMethods = obj.secureMethods;
				
					for(j=1; j <= listLen(allPermissions.admin[ section ].secureMethods); j++){
						
						var item = listGetAt(allPermissions.admin[ section ].secureMethods, j);
						
						arrayAppend(allPermissions.admin[ section ].securePermissionOptions, {
							name=rbKey( 'permission.#section#.#item#' ),
							value="admin#section##item#"
						});
					}
				}
			}
			
			// Setup Integration Permissions
			var activeFW1Integrations = getIntegrationService().getActiveFW1Subsystems();
			for(var i=1; i <= arrayLen(activeFW1Integrations); i++){
				
				allPermissions[ activeFW1Integrations[i].subsystem ] = {};
				
				var integrationDirectoryList = directoryList( expandPath("/Slatwall/integrationServices/#activeFW1Integrations[i].subsystem#/controllers"), false, "path", "*.cfc" );
				for(var j=1; j <= arrayLen(integrationDirectoryList); j++){
					
					var section = listFirst(listLast(integrationDirectoryList[j],"/\"),".");
					var obj = createObject('component','Slatwall.integrationServices.#activeFW1Integrations[i].subsystem#.controllers.#section#');
					
					allPermissions[ activeFW1Integrations[i].subsystem ][ section ] = {
						publicMethods = "",
						secureMethods = "",
						anyAdminMethods = "",
						securePermissionOptions = []
					};
					
					if(structKeyExists(obj, 'publicMethods')){
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].publicMethods = obj.publicMethods;
					}
					if(structKeyExists(obj, 'anyAdminMethods')){
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].anyAdminMethods = obj.anyAdminMethods;
					}
					if(structKeyExists(obj, 'secureMethods')){	
						allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods = obj.secureMethods;
					
						for(k=1; k <= listLen(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods); k++){
							
							var item = listGetAt(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].secureMethods, k);
							
							arrayAppend(allPermissions[ activeFW1Integrations[i].subsystem ][ section ].securePermissionOptions, {
								name="#activeFW1Integrations[i].subsystem#:#section#.#item#",
								value="#activeFW1Integrations[i].subsystem##section##item#"
							});
						}
					}
					
				}
			}
			
			variables.permissions = allPermissions;
		}
		return variables.permissions;
	}
	
	public function setupDefaultPermissions(){
		var accounts = getDAO().getMissingUserAccounts();
		var permissionGroup = get('PermissionGroup',{permissionGroupID='4028808a37037dbf01370ed2001f0074'});
		
		for(i=1; i <= accounts.recordcount; i++){
			account = get('Account',{accountID=accounts.accountID[i]});
			account.addPermissionGroup(permissionGroup);
		}
		//getDAO().FlushORMSession();
	}
	
}