component extends="coldbox.system.Interceptor" {

	property name="timezoneDefinitionService" inject="delayedInjector:TimezoneDefinitionService";

// PUBLIC
	public void function configure() {}

	public void function postPresideReload() {
		if ( !timezoneDefinitionService.initialSetupHasRun() ) {
			timezoneDefinitionService.setupInitialTimezoneData();
			timezoneDefinitionService.initialSetupHasRun( true );
		}
	}
}