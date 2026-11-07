package com.greensock.loading
{
   import flash.events.Event;
   import flash.text.StyleSheet;
   
   [Event(name="httpStatus",type="com.greensock.events.LoaderEvent")]
   public class CSSLoader extends DataLoader
   {
      
      private static var _classActivated:Boolean = _activateClass("CSSLoader",CSSLoader,"css");
      
      public function CSSLoader(urlOrRequest:*, vars:Object = null)
      {
         super(urlOrRequest,vars);
         _loader.dataFormat = "text";
         _type = "CSSLoader";
      }
      
      override protected function _receiveDataHandler(event:Event) : void
      {
         var style:StyleSheet = _content = new StyleSheet();
         style.parseCSS(_loader.data);
         super._completeHandler(event);
      }
   }
}

