component {
	property name="timeZoneSelectService" inject="TimeZoneSelectService";

	public string function index( event, rc, prc, args={} ) {
		var defaultToSystemTimezone = isTrue( args.defaultToSystemTimezone ?: "" );
		var systemTimeZone          = getTimezone();
		var timeZones               = timeZoneSelectService.getExtendedTimeZones();
		var description             = "";
		var deprecated              = translateResource( uri="formcontrols.timeZoneSelect:deprecated" );

		args.values = [ "" ];
		args.labels = [ "" ];

		if ( !len( args.defaultValue ?: "" ) && defaultToSystemTimezone ) {
			args.defaultValue = systemTimeZone;
		}

		for( var timeZone in timeZones ) {
			if ( Left( timeZone.id, 4 ) == "Etc/" ) {
				description = "** #deprecated# **";
			} else {
				description = timeZone.name;
				if ( isTrue( timeZone.useDst ) ) {
					description &= "/" & timeZone.dstName;
				}
				description = "[#description#]";
			}
			ArrayAppend( args.labels, "#timeZone.id# #description#" );
			ArrayAppend( args.values, timeZone.id );
		}

		return renderView( view="/formcontrols/select/index", args=args );
	}

}