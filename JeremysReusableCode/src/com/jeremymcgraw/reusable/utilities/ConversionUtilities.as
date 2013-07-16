package com.jeremymcgraw.reusable.utilities
{
	public class ConversionUtilities
	{	
		public static const FEET_IN_METERS:Number = 0.3048;
		
		public function ConversionUtilities()
		{
			// Static class members can be accessed from within instance functions
			trace(FEET_IN_METERS);
		}
		
		// In a static function you do not have access to a instance variable/functions
		public static function convertFeetToMeters(feet:Number):Number
		{
			var meters:Number = feet * FEET_IN_METERS;
			return meters;
		}
	}
}