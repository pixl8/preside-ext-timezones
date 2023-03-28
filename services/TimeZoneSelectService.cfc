/**
 * Provides methods for populating the timeZoneSelect form control.
 *
 * @singleton
 * @presideservice
 *
 */
component extends="preside.system.services.formcontrols.TimezoneSelectService" {


// PUBLIC METHODS
	public query function getExtendedTimeZones() {
		if ( StructKeyExists( variables, "extendedTimezoneQuery" ) ) {
			return variables.extendedTimezoneQuery;
		}

		var timezoneClass    = createObject( "java", "java.util.TimeZone" );
		var i18n             = _getI18n();
		var timezones        = i18n.getAvailableTZ();
		var timezoneQuery    = queryNew( "" );
		var ids              = [];
		var offsets          = [];
		var formattedOffsets = [];
		var names            = [];
		var dstNames         = [];
		var useDst           = [];

		for( var timezone in timezones ) {
			if ( timezone == "US/Pacific-New" ) {
				continue;
			}

			if ( listLen( timezone, "/" ) > 1 && !listFindNoCase( "SystemV", listFirst( timezone, "/" ) ) ) {
				var timezoneObject = timezoneClass.getTimeZone( timezone );
				var usesDst        = timezoneObject.useDaylightTime();
				var offset         = i18n.getRawOffset( timezone );

				ids.append( timezone );
				offsets.append( offset );
				formattedOffsets.append( _formatOffset( offset ) );
				names.append( timezoneObject.getDisplayName( false, 1 ) );
				dstNames.append( usesDst ? timezoneObject.getDisplayName( true, 1 ) : "" );
				useDst.append( usesDst );
			}
		}

		timezoneQuery.addColumn( "id"             , "varchar", ids              );
		timezoneQuery.addColumn( "offset"         , "double" , offsets          );
		timezoneQuery.addColumn( "formattedOffset", "double" , formattedOffsets );
		timezoneQuery.addColumn( "name"           , "varchar", names            );
		timezoneQuery.addColumn( "dstName"        , "varchar", dstNames         );
		timezoneQuery.addColumn( "useDst"         , "bit"    , useDst           );

		variables.extendedTimezoneQuery = queryExecute(
			  sql     = "select id, offset, formattedOffset, name, dstName, useDst from timezoneQuery order by id"
			, options = { dbtype="query" }
		);

		return variables.extendedTimezoneQuery;
	}

}

