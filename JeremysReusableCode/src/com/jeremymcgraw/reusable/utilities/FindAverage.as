package com.jeremymcgraw.reusable.utilities
{
	public class FindAverage
	{
		public function FindAverage()
		{
			
		}
		
		public static function average(num:Array):Number
		{		
			var initialValue:Number = 0;
			var findAverage:Number;
			
			for each(var n:Number in num) {
				
				initialValue += n;
				
				findAverage = initialValue;
			}
			
			findAverage = findAverage / num.length;
			
			return findAverage;
		}
	}
}