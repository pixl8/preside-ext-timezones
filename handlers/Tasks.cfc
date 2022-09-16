component {
	property name="timezoneDefinitionService" inject="TimezoneDefinitionService";

	/**
	 * Import timezone definitions
	 *
	 * @schedule     0 30 0 1 * *
	 * @displayName  Import timezone definitions
	 */
	private boolean function importTimezones( logger ) {
		return timezoneDefinitionService.importTimezones( arguments.logger ?: NullValue() );
	}
}