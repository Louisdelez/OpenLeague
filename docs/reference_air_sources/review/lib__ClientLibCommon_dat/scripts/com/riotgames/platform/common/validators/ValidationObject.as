package com.riotgames.platform.common.validators
{
   import flash.display.DisplayObject;
   
   public class ValidationObject
   {
      
      public var required:Boolean;
      
      public var objectToMatch:DisplayObject;
      
      public var property:String;
      
      public var expression:String;
      
      [Inspectable(attribute="value",type="String",enumeration="string,number,email,birthday,regexp,object",defaultValue="String")]
      public var type:String;
      
      public var source:DisplayObject;
      
      public var propertyToMatch:String;
      
      public var errorMessage:String;
      
      public function ValidationObject()
      {
         super();
      }
   }
}

