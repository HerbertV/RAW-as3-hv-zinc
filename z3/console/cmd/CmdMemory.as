/*
 *  __  __      
 * /\ \/\ \  __________   
 * \ \ \_\ \/_______  /\   
 *  \ \  _  \  ____/ / /  
 *   \ \_\ \_\ \ \/ / / 
 *    \/_/\/_/\ \ \/ /  
 *             \ \  /
 *              \_\/
 *
 * -----------------------------------------------------------------------------
 * @author: Herbert Veitengruber 
 * @version: 1.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.zinc.z3.console.cmd
{
	import mdm.*;

	import flash.utils.getTimer;
	import flash.system.System;
	import flash.display.Sprite;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.hv.core.math.TrueRandom;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.AbstractMonitoringView;
	import as3.hv.core.console.DebugLevel;
	import as3.hv.core.console.UIHeadline;
	import as3.hv.core.console.UIStyles;
	import as3.hv.core.console.UIButtonMinMax;
	
	// =========================================================================
	// Class CmdMemory
	// =========================================================================
	// shows a memory monitor 
	// uses the zinc feature to access the max memory
	// since CmdMemory is a Singleton we do not override/extend the original 
	// command 
	public class CmdMemory
			extends AbstractMonitoringView
			implements IConsoleCommand 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const CMD:String = "mem";
		
		public static const B_TO_MB_MULTIPLIER:Number = 0.000000954; 
		public static const KB_TO_MB_MULTIPLIER:Number = 0.0009765625; 
		
		// =====================================================================
		// Variables
		// =====================================================================	
		// static singleton instance 
		private static var myInstance:CmdMemory = new CmdMemory();
		
		private var memPeak:Number = 0;
		private var memMax:Number = 0;
		private var memMin:Number = 0;
		private var memRange:Number = 0;
		
		private var headline:UIHeadline;
		
		private var lblMin:TextField;
		private var lblMax:TextField;
		private var lblPeak:TextField;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CmdMemory()
		{
			super(250,100);
			
			if ( myInstance ) 
				throw new Error ("CmdMemory is a singleton class, use getInstance() instead");    
			
			this.minimizedWidth = 120;
			
			memMin = TrueRandom.trunc( 
					(System.totalMemory * B__TO_MB_MULTIPLIER),
					3
				);
			memMax = TrueRandom.trunc( 
					(mdm.System.RAMSize * KB_TO_MB_MULTIPLIER),
					3
				);
			memPeak = memMin;
			// memRange is in this implementation constant,
			// since we know the systems ram size
			memRange = memMax - memMin;
			
			this.headline = new UIHeadline(
					250,
					25,
					"MEM:" + memMin
				);
			
			this.graphWidth = currentWidth - 16;
			this.graphHeight = currentHeight - 35;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getInstance
		 * ---------------------------------------------------------------------
		 *
		 * @returns 	the instance of the CmdMemory
		 */
		public static function getInstance():CmdMemory
		{
			return CmdMemory.myInstance;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * layout
		 * ---------------------------------------------------------------------
		 */
		override protected function layout():void
		{
			super.layout();
			
			if( viewState == VIEW_STATE_MINIMIZED )
			{
				this.headline.layout(minimizedWidth,25,true);
				
				this.dragHandle.graphics.clear();
				this.dragHandle.graphics.lineStyle();
				this.dragHandle.graphics.beginFill(0xFF0000,0.0);
				this.dragHandle.graphics.drawRect(
						1,
						1,
						minimizedWidth - 2,
						minimizedHeight
					);
				this.dragHandle.graphics.endFill();
				
				this.spGraph.visible = false;
				this.lblMin.visible = false;
				this.lblMax.visible = false;
				this.lblPeak.visible = false;
				
				return;
			}
			
			if( viewState == VIEW_STATE_MAXIMIZED )
			{
				this.headline.layout(currentWidth,25);
				
				this.dragHandle.graphics.clear();
				this.dragHandle.graphics.lineStyle();
				this.dragHandle.graphics.beginFill(0xFF0000,0.0);
				this.dragHandle.graphics.drawRect(
						1,
						1,
						currentWidth - 2,
						currentHeight
					);
				this.dragHandle.graphics.endFill();
				
				this.spGraph.visible = true;
				this.lblMin.visible = true;
				this.lblMax.visible = true;
				this.lblPeak.visible = true;
				
			}
		}
		/**
		 * ---------------------------------------------------------------------
		 * doCommand
		 * ---------------------------------------------------------------------
		 * @see IConsoleCommand 
		 *
		 * @param args 		
		 */
		public function doCommand(args:Array):void
		{			
			if( this.stage == null )
				Console.getInstance().parent.addChild(this);
			else 
				Console.getInstance().parent.removeChild(this);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 */
		public function shortHelp():String
		{
			return "'" + CMD + "' - [z3] show/hide the Memory monitor";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 */
		public function longHelp():String
		{
			return "USAGE: " + CMD 
					+ " [no args ]<br> - Extended Zinc 3 memory monitor"
					+ "<br> show/hide the Memory monitor";
		}
		
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * updateOnEnterFrame Event
		 * ---------------------------------------------------------------------
		 * 
		 * @param e 		Event
		 */
		override protected function updateOnEnterFrame(e:Event):void
		{
			var now:uint = getTimer();
			var d:uint = now - this.updateTimer;
			// update only after threshold is reached
			if( d < this.updateThreshold )
				return;
				
			this.updateTimer = now;
			
			var memInMB:Number = TrueRandom.trunc(
					(System.totalMemory * TO_MB_MULTIPLIER),
					3
				);
			
			if( memPeak < memInMB )
				memPeak = memInMB;
			
			if( memMin > memInMB )
				memMin = memInMB;
			
			var currentValue:int = ((memInMB-memMin) / memRange) * graphHeight ;
			
			this.headline.setLabel("MEM: " + memInMB + "MB");
			this.lblMin.text = "MIN: "+ memMin;
			this.lblMax.text = "MAX: "+ memMax;
			this.lblPeak.text = "PEAK: "+ memPeak;
			
			this.updateGraph(currentValue);
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addedToStage Event
		 * ---------------------------------------------------------------------
		 * 
		 * @param e 		Event
		 */
		override protected function addedToStage(e:Event):void
		{
			// init
			super.addedToStage(null);
			
			// headline
			this.addChild(this.headline);
			
			this.dragHandle = new Sprite();
			this.addChild(this.dragHandle);
			this.setupDragging(true);
			
			// min max button
			this.btnViewMinMax = new UIButtonMinMax();
			this.addChild(this.btnViewMinMax);
			this.btnViewMinMax.x = 23;
			this.btnViewMinMax.y = 11;
			this.btnViewMinMax.addEventListener(
					MouseEvent.CLICK, 
					toggleViewState
				);
			
			
			var lblFormat:TextFormat = new TextFormat();
			lblFormat.font = "Arial";
			lblFormat.color = 0xA0A0A0;
			lblFormat.size = 9;
			
			this.lblMax = new TextField();
			this.lblMax.defaultTextFormat = lblFormat;
			this.lblMax.text = "MAX:";
			this.lblMax.x = 8;
			this.lblMax.y = 30;
			this.lblMax.height = 15;
			this.lblMax.selectable = false;
			this.addChild(this.lblMax);
			
			this.lblPeak = new TextField();
			this.lblPeak.defaultTextFormat = lblFormat;
			this.lblPeak.text = "PEAK:";
			this.lblPeak.x = 8;
			this.lblPeak.y = 50;
			this.lblPeak.height = 15;
			this.lblPeak.selectable = false;
			this.addChild(this.lblPeak);
						
			this.lblMin = new TextField();
			this.lblMin.defaultTextFormat = lblFormat;
			this.lblMin.text = "MIN:";
			this.lblMin.x = 8;
			this.lblMin.y = currentHeight - 18;
			this.lblMin.height = 15;
			this.lblMin.selectable = false;
			this.addChild(this.lblMin);
			
			this.layout();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removedFromStage Event
		 * ---------------------------------------------------------------------
		 *
		 * @param e 		Event
		 */
		override protected function removedFromStage(e:Event):void
		{
			//dealloc
			super.removedFromStage(e);
			
			this.btnViewMinMax.removeEventListener(
					MouseEvent.CLICK, 
					toggleViewState
				);
			
			this.btnViewMinMax = null;
			this.lblMin = null;
			this.lblMax = null;
			this.lblPeak = null;
		}
	
	}
}