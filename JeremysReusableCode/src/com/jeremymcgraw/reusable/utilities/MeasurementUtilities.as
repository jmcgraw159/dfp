package com.jeremymcgraw.reusable.utilities
{
	public class MeasurementUtilities
	{	
		public static const FEET:Number = 0.0833333
		public static const YARDS:Number = 0.333333;
		public static const CM:Number = 30.48;
		
		public function MeasurementUtilities()
		{
			
		}
		
		public static function convertInchesToFeet(inches:Number):Number
		{
			var feet:Number = inches * FEET;
			return feet;
		}
		
		public static function convertFeetToYards(feet:Number):Number
		{
			var yards:Number = feet * YARDS;
			return yards;
		}
		
		public static function convertFeetToCentimeters(feet:Number):Number
		{
			var centimeters:Number = feet * CM;
			return centimeters;
		}
	}
}