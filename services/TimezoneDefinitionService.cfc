/**
 * @singleton
 * @presideService
 */
component {

	// CONSTRUCTOR
	/**
	 * @timezoneSelectService.inject  TimezoneSelectService
	 *
	 */
	public any function init( required any timezoneSelectService ) {
		_setTimezoneSelectService( arguments.timezoneSelectService );

		return this;
	}

	public query function getTimezone( required string timezoneId ) {
		return $getPresideObject( "timezone" ).selectData( id=arguments.timezoneId );
	}

	public boolean function importTimezones( any logger ) {
		var canLog         = StructKeyExists( arguments, "logger" );
		var canInfo        = canLog && arguments.logger.canInfo();
		var canWarn        = canLog && arguments.logger.canWarn();
		var canError       = canLog && arguments.logger.canError();

		var timezones      = _getTimezoneSelectService().getTimeZones();
		var tzId           = "";
		var vTimezone      = "";
		var dao            = $getPresideObject( "timezone" );
		var updated        = false;
		var timezoneResult = {};

		if ( canInfo ) {
			arguments.logger.info( "Found [#timezones.recordcount#] timezones. Importing definitions now..." );
		}

		for( var timezone in timezones ) {
			try {
				timezoneResult = {};
				http url="http://tzurl.org/zoneinfo-outlook/#EncodeForUrl( timezone.id )#" result="timezoneResult" charset="utf-8" timeout="10";

				if ( !FindNoCase( "BEGIN:VTIMEZONE", timezoneResult.fileContent ) ) {
					if ( canInfo ) {
						arguments.logger.warn( "#timezone.id# : no timezone definition found" );
					}
					continue;
				}
				vTimezone = Trim( ReReplaceNoCase( timezoneResult.fileContent, "^.*(BEGIN:VTIMEZONE.+END:VTIMEZONE).*$", "\1" ) );
				tzId      = ReReplaceNoCase( vTimezone, "^.*TZID:([^\s]+).*$", "\1" );

				updated = dao.updateData(
					  id   = timezone.id
					, data = { tzid=tzId, vtimezone=vTimezone }
				);
				if ( !updated ) {
					dao.insertData( data={
						  id        = timezone.id
						, tzid      = tzId
						, vtimezone = vTimezone
					} );
				}
				if ( canInfo ) {
					arguments.logger.info( "#timezone.id# : imported" );
				}
			} catch( any e ){
				vTimezone = "";
				if ( canError ) {
					arguments.logger.error( "#timezone.id# : #e.message#" );
				}
			};
		}

		if ( canInfo ) {
			arguments.logger.info( "Finished importing timezone definitions." );
		}

		return true;
	}

	public void function setupInitialTimezoneData() {
		var dao = $getPresideObject( "timezone" );

		if ( dao.dataExists() ) {
			return;
		}

		var localData = FileOpen( ExpandPath( "/application/extensions/preside-ext-timezones/config/data/timezones.jsonl" ) );
		var timezone  = "";

		try {
			while( !FileIsEoF( localData ) ) {
				timezone = FileReadLine( localData );
				dao.insertData( data=DeserializeJSON( timezone ) );
			}
		} catch( any e ) {
			rethrow;
		} finally {
			FileClose( localData );
		}
	}

	public boolean function initialSetupHasRun( boolean hasRun ) {
		var key = "initialSetupHasRun";

		if ( StructKeyExists( arguments, "hasRun" ) ) {
			$getSystemConfigurationService().saveSetting( category="timezonedata", setting=key, value=arguments.hasRun );
			return arguments.hasRun;
		}

		var hasRun = $getPresideSetting( category="timezonedata", setting=key, default=false );
		return IsBoolean( hasRun ) && hasRun;
	}


// GETTER & SETTER
	private any function _getTimezoneSelectService() {
	    return _timezoneSelectService;
	}
	private void function _setTimezoneSelectService( required any timezoneSelectService ) {
	    _timezoneSelectService = arguments.timezoneSelectService;
	}

}