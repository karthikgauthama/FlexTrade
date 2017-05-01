package com.flextrade.vo
{
	[Bindable]
	public class Trading
	{
		private var _pair:String
		private var _buy:Number;
		private var _sell:Number;
		public function Trading()
		{
		}

		public function get sell():Number
		{
			return _sell;
		}

		public function set sell(value:Number):void
		{
			_sell = value;
		}

		public function get buy():Number
		{
			return _buy;
		}

		public function set buy(value:Number):void
		{
			_buy = value;
		}

		public function get pair():String
		{
			return _pair;
		}

		public function set pair(value:String):void
		{
			_pair = value;
		}

	}
}