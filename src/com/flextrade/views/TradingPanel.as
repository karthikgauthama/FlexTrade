/////////////////////////////////////////
// Author: KARTHIK ANANTHARAMAIAH
// Date Created: Apr-30-2017
// Date Modified: May-1-2017
///////////////////////////////////////

package com.flextrade.views
{
	//import flash.display.DisplayObject;
	
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Label;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.Panel;
	import spark.components.TextArea;
	import spark.formatters.NumberFormatter;
	
	
	/**
	 * Skin state that defines Mouse over on Buy Part
	 */
	[SkinState("buyover")];
	
	/**
	 * Skin state that defines Mouse over on Sell Part
	 */
	
	[SkinState("sellOver")];
	
	/**
	 * Event that dispatches when there is a change in data
	 */
	
	[Event(name="dataChangeEvent", type="flash.events.Event")]
	
	public class TradingPanel extends Panel
	{
		public var text_mc:TextArea;
		
		public var timer:Timer;
		
		public var mxLabel:mx.controls.Label;
		
		[Bindable]
		private var _data:Object
		
		[SkinPart(required="true")]
		public var sellGroup:Group;
		
		[SkinPart(required="true")]
		public var buyGroup:Group;
		
		[SkinPart(required="true")]
		public var buyValue:spark.components.Label;
		
		[SkinPart(required="true")]
		public var buyCurrency:spark.components.Label;
		
		[SkinPart(required="true")]
		public var buyValueLast:spark.components.Label;
		
		[SkinPart(required="true")]
		public var sellLow:spark.components.Label;
		
		[SkinPart(required="true")]
		public var sellHigh:spark.components.Label;
		
		[SkinPart(required="true")]
		public var sellCurrency:spark.components.Label;
		
		[SkinPart(required="true")]
		public var buyValuePow:spark.components.Label;
		
		[SkinPart(required="true")]
		public var sellPow:spark.components.Label;
		
		
		[Bindable]
		private var _skinState:String;
		
		
		[Embed(source="../../../assets/uparrow.png")]
		public var buyHighImg:Class
		
		[Embed(source="../../../assets/downarow.png")]
		public var buyLowImg:Class
		
		[SkinPart(required="true")]
		public var tradeImg:Image;
		
		public var helperString:String;
		
		[Bindable]
		public var originalBuyValue:Number;
		
		[Bindable]
		public var originalSellValue:Number;
		
		[Bindable]
		public var numberFormatter:NumberFormatter;
		
		[Bindable]
		public var array:Array;
		public function TradingPanel()
		{
			super();
			this.addEventListener("dataChangeEvent",onDataChange);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,onCreationComplete);
			
			numberFormatter = new NumberFormatter();
			numberFormatter.fractionalDigits = 10;
		}
		
		public function onCreationComplete(event:FlexEvent):void
		{
			
			this.width = 250;
			this.height=115;
			setStyle("backgroundColor","#F0F0F2");
			
			
			timer = new Timer(1000,1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComplete);
			timer.start();
			
			//BindingUtils.
		}
		
		//This method will change the indicator based on buy/sell price
		public function onDataChange(event:Event):void
		{
			if(Number(data.buy) > Number(data.sell))
				tradeImg.source = buyHighImg;
			else
				tradeImg.source = buyLowImg; 
			
			tradeImg.validateNow();
		}
		
		//This method is used to format extra 0's on Math operation
		public function decimalFormater(val:String):String
		{
			array = val.split(".");
			val = array[1];
			for(var i:int=val.length-1;i>=0;i--)
			{
				if(val.charAt(i) != "0")
				{
					return array[0]+"."+ val.slice(0,i+1);
				}
			}
			
			return val;
		}
		
		public function onTimerComplete(event:TimerEvent):void
		{
			var arr:Array = new Array();
			if(event.type == TimerEvent.TIMER_COMPLETE)
			{
				helperString = String(Math.random());
				if(Number(helperString.substr(helperString.length-1,helperString.length))>5)
					helperString = decimalFormater(numberFormatter.format(originalBuyValue + originalBuyValue*0.1));
				else
					helperString = decimalFormater(numberFormatter.format(originalBuyValue - originalBuyValue*0.1));
				
				data.buy = helperString;
				this.buyValue.text = helperString.substring(0,helperString.length-3);
				this.buyValueLast.text = helperString.substring(helperString.length-3,helperString.length-1);
				this.buyValuePow.text = helperString.substring(helperString.length-1,helperString.length);
				helperString = String(Math.random());
				if(Number(helperString.substr(helperString.length-1,helperString.length))>5)
				{
					helperString = decimalFormater(numberFormatter.format(originalSellValue- (originalSellValue*0.1)));
				}
				else
				{
					helperString =decimalFormater(numberFormatter.format(originalSellValue +originalSellValue*0.1));
				}
				data.sell = helperString;
				this.sellLow.text =  helperString.substring(0,helperString.length-3);
                this.sellHigh.text = helperString.substring(helperString.length-3,helperString.length-1);
				this.sellPow.text = helperString.substring(helperString.length-1,helperString.length);
				dispatchEvent(new Event("dataChangeEvent"));
				invalidateDisplayList();
				timer.start();
			}
			
		}
		[Bindable]
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
			originalBuyValue = Number(value.buy);
			originalSellValue = Number(value.sell);
		}

		public function get skinState():String
		{
			return _skinState;
		}

		public function set skinState(value:String):void
		{
			_skinState = value;
		}

		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			var str:String
			super.partAdded(partName,instance);
			
			if(instance == buyGroup)
			{
				buyGroup.addEventListener(MouseEvent.MOUSE_OUT,onBuyGrpSelect);
				buyGroup.addEventListener(MouseEvent.MOUSE_OVER,onBuyGrpSelect);
				
			}
			
			if(sellGroup == instance)
			{
				sellGroup.addEventListener(MouseEvent.MOUSE_OVER,onSellGroupSelect);
				sellGroup.addEventListener(MouseEvent.MOUSE_OUT,onSellGroupSelect);
			}
			
			if(instance == buyCurrency)
			{
				str = data.pair;
				buyCurrency.text = "Buy"+" "+str.split(" ")[0];//Can be validated; but the given Data works for this.
			}
			
			if(instance == sellCurrency)
			{
				str = data.pair;
				sellCurrency.text = "Sell"+" "+str.split(" ")[0];
			}
			if(instance  == buyValue)
			{
				buyValue.text = data.buy;
				
			}
			if(instance == titleDisplay)
			{
				titleDisplay.text = data.pair;
			}
			
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if(instance == buyGroup)
			{
				buyGroup.removeEventListener(MouseEvent.MOUSE_OUT,onBuyGrpSelect);
				buyGroup.removeEventListener(MouseEvent.MOUSE_OVER,onBuyGrpSelect);
				
			}
			
			if(sellGroup == instance)
			{
				sellGroup.removeEventListener(MouseEvent.MOUSE_OVER,onSellGroupSelect);
				sellGroup.removeEventListener(MouseEvent.MOUSE_OUT,onSellGroupSelect);
			}
			
		}
		
		
		
		public function onSellGroupSelect(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_OVER)
			{
				skinState = "sellOver";
			}
			if(event.type == MouseEvent.MOUSE_OUT)
			{
				skinState = "normal";
			}
			invalidateSkinState();
		}
		
		public function onBuyGrpSelect(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_OVER)
			{
				skinState = "buyover";
			}
			if(event.type == MouseEvent.MOUSE_OUT)
			{
				skinState = "normal";
			}
			invalidateSkinState();
			
		}
		
		override protected function getCurrentSkinState():String
		{
			return skinState;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			super.updateDisplayList(unscaledWidth,unscaledHeight)
			
		}
		
		
		
		
	}
}