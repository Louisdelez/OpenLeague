package com.riotgames.rust.components.text
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import flash.text.TextField;
   
   public class HTMLTextFieldProxy extends TextFieldProxy
   {
      
      public static const APPLICATION_FONT_1:String = "ApplicationFont1";
      
      public static const APPLICATION_FONT_2:String = "ApplicationFont2";
      
      private var _fontOverride:String = "ApplicationFont2";
      
      public function HTMLTextFieldProxy(param1:IContext, param2:TextField = null, param3:String = "ApplicationFont2")
      {
         super(param1,param2);
         this._fontOverride = param3;
      }
      
      override public function setHtmlText(param1:String) : void
      {
         super.setHtmlText("<font face=\'" + this._fontOverride + "\'>" + param1 + "</font>");
      }
   }
}

