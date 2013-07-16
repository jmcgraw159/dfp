package com.jeremymcgraw.reusable.utilities
{
	public class AverageNumOfEps
	{	
		public function AverageNumOfEps()
		{
		}
		
		public static function findAverageNumOfEps(startYear:uint, endYear:uint):uint
		{
			var average:uint = (endYear - startYear) + 1;
			return average;
		}
		
		public static function findAverageNumofEpsPerYear(average:uint, numEps:uint):uint
		{
			var perYear:uint = numEps / average;
			return perYear;
		}
	}
}