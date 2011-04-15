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
<cfparam name="rc.product" type="any" />

<cfoutput>
	<div class="svofrontendproductdetail">
		<div class="image">
			Image Here
		</div>
		<cf_PropertyDisplay object="#rc.Product#" property="productCode">
		<cf_PropertyDisplay object="#rc.Product#" property="productYear">
		<div class="description">#rc.product.getProductDescription()#</div>
		<form action="#buildURL(action='frontend:product.addtocart')#" method="post">
			<input type="hidden" name="productID" value="#rc.product.getProductID()#" />
			<cfset local.productOptionGroups = rc.product.getOptionGroupsStruct() />
			<cfloop collection="#local.productOptionGroups#" item="local.groupID">
				<dt>#local.productOptionGroups[local.groupID].getOptionGroupName()#</dt>
				<dd>
				<select name="selectedOptions">
					<cfset local.availableOptions = rc.product.getAvailableGroupOptionsBySelectedOptions(optionGroupID=local.groupID) />
					<cfloop collection="#local.availableOptions#" item="local.optionID">
						<option selected="selected" value="#local.availableOptions[local.optionID].getOptionID()#">#local.availableOptions[local.optionID].getOptionName()#</option>
					</cfloop>
				</select>
				</dd>
			</cfloop>
			<button type="submit">Add To Cart</button>
		</form>
	</div>
</cfoutput>
