component {

	public void function configure( required struct config ) {
		var conf     = arguments.config;
		var settings = conf.settings ?: {};

		conf.interceptors.prepend( { class="app.extensions.preside-ext-timezones.interceptors.TimezoneDefinitionInterceptor", properties={} } );
	}
}
