package com.riotgames.rust.decorator
{
   import blix.util.string.strReplace;
   import blix.util.string.strTrim;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class LocaleDecorator extends DisplayGraphDecorator
   {
      
      private var bundleName:String;
      
      public function LocaleDecorator(param1:String)
      {
         super(TextField);
         this.bundleName = param1;
      }
      
      override protected function decorate(param1:DisplayObject) : void
      {
         var _loc2_:TextField = param1 as TextField;
         var _loc3_:String = _loc2_.text;
         if(_loc3_.substr(0,2) !== "**")
         {
            return;
         }
         var _loc4_:String = strTrim(_loc3_.substr(2));
         var _loc5_:IResourceManager = ResourceManager.getInstance();
         var _loc6_:String = _loc5_.getString(this.bundleName,_loc4_);
         if(_loc6_ == null)
         {
            _loc6_ = "**" + _loc4_;
         }
         else
         {
            _loc6_ = strReplace(_loc6_,"\\n","\n");
         }
         _loc2_.text = _loc6_;
      }
   }
}

