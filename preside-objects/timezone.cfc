/**
 * @labelfield id
 * @versioned  false
 */

component {
	property name="id"        type="string" dbtype="varchar" maxlength=100 required=true generator="none";
	property name="tzid"      type="string" dbtype="varchar" maxLength=100;
	property name="vtimezone" type="string" dbtype="text";
}