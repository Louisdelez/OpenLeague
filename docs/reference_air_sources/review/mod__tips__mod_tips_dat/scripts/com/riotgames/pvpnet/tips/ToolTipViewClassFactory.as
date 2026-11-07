package com.riotgames.pvpnet.tips
{
   import blix.factory.ClassFactory;
   
   public class ToolTipViewClassFactory extends ClassFactory
   {
      
      private var _instance:*;
      
      public function ToolTipViewClassFactory(param1:Class, param2:Array = null)
      {
         super(param1,param2);
      }
      
      override public function getInstance() : *
      {
         if(this._instance == null)
         {
            this._instance = super.getInstance();
         }
         return this._instance;
      }
   }
}

