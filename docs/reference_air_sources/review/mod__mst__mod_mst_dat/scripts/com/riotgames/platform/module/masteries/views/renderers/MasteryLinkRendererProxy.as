package com.riotgames.platform.module.masteries.views.renderers
{
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.masteries.Talent;
   
   public class MasteryLinkRendererProxy extends StatefulView
   {
      
      private var _rawCurrentState:String;
      
      private var _max:Boolean = false;
      
      public var parentMastery:Talent;
      
      private var _lengthIndicator:int = 1;
      
      private var _activated:Boolean = false;
      
      public var childMastery:Talent;
      
      public function MasteryLinkRendererProxy(param1:IContext)
      {
         super(param1);
         setLinkage("MasteryLinkRenderer");
         this.setCurrentState("inactive1");
      }
      
      public function get maxed() : Boolean
      {
         return this._max;
      }
      
      public function set maxed(param1:Boolean) : void
      {
         if(this._max != param1)
         {
            this._max = param1;
         }
      }
      
      public function set activated(param1:Boolean) : void
      {
         if(this._activated != param1)
         {
            if(param1 == this._activated)
            {
               return;
            }
            this._activated = param1;
         }
      }
      
      public function get activated() : Boolean
      {
         return this._activated;
      }
      
      public function set lengthIndicator(param1:int) : void
      {
         this._lengthIndicator = param1;
      }
      
      override public function setCurrentState(param1:String) : void
      {
         this._rawCurrentState = param1;
         super.setCurrentState(this._rawCurrentState + this._lengthIndicator.toString());
      }
   }
}

