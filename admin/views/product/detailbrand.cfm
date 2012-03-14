<!---

    Slatwall - An e-commerce plugin for Mura CMS
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

--->
<cfparam name="rc.brand" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	
<cfif rc.edit>
	<!--- #$.slatwall.getValidateThis().getValidationScript(theObject=rc.brand, formName="brandDetail")# --->
	<form method="post" action="?update=1">
		<input type="hidden" name="slatAction" value="admin:product.savebrand" />
		<input type="hidden" name="BrandID" value="#rc.Brand.getBrandID()#" />
</cfif>

		<div class="actionnav well well-small">
			<div class="row-fluid">
				<div class="span4"><h1>#$.slatwall.rbKey(replace(rc.slatAction,':','.','all'))#<cfif !rc.brand.isNew()> - #rc.brand.getBrandName()#</cfif></h1></div>
				<div class="span8">
					<div class="btn-toolbar">
						<div class="btn-group">
							<cf_SlatwallActionCaller action="admin:product.listbrands" class="btn">
						</div>
						<div class="btn-group">
							<cfif rc.edit>
								<cfif rc.brand.isNew()>
									<cf_SlatwallActionCaller action="admin:product.listbrands" text="#rc.$.Slatwall.rbKey('define.cancel')#" class="btn btn-inverse">
								<cfelse>
									<cf_SlatwallActionCaller action="admin:product.detailbrand" querystring="brandid=#rc.brand.getBrandID()#" text="#rc.$.Slatwall.rbKey('define.cancel')#" class="btn btn-inverse">
									<cf_SlatwallActionCaller action="admin:product.deletebrand" querystring="brandid=#rc.brand.getBrandID()#" text="#rc.$.slatwall.rbKey('define.delete')#" class="btn btn-danger" confirm="true" disabled="#rc.brand.isNotDeletable()#">
								</cfif>
								<cf_SlatwallActionCaller action="admin:product.savebrand" text="#rc.$.Slatwall.rbKey('define.save')#" class="btn btn-success" type="button" submit="true">
							<cfelse>
								<cf_SlatwallActionCaller action="admin:product.editbrand" querystring="brandid=#rc.brand.getBrandID()#" text="#rc.$.Slatwall.rbKey('define.edit')#" class="btn btn-primary" submit="true">
							</cfif>
						</div>
					</div>
				</div>
			</div>
		</div>
		
		<cf_SlatwallMessageDisplay />
		
		<dl class="dl-horizontal">
			<cf_SlatwallPropertyDisplay object="#rc.Brand#" property="brandName" edit="#rc.edit#" class="first">
			<cf_SlatwallPropertyDisplay object="#rc.Brand#" property="brandWebsite" edit="#rc.edit#">
		</dl>

<cfif rc.edit>
		
	</form>
</cfif>
	
</cfoutput>
