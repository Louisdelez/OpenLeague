package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   
   public class IQ extends XMPPStanza implements ISerializable
   {
      
      public static var SET_TYPE:String = "set";
      
      public static var GET_TYPE:String = "get";
      
      public static var RESULT_TYPE:String = "result";
      
      public static var ERROR_TYPE:String = "error";
      
      private var myCallback:String;
      
      private var myCallbackScope:Object;
      
      private var myCallbackFunc:Function;
      
      private var myQueryName:String;
      
      private var myQueryFields:Array;
      
      public function IQ(param1:EscapedJID = null, param2:String = null, param3:String = null, param4:String = null, param5:Object = null, param6:Function = null)
      {
         var _loc7_:String = exists(param3) ? param3 : generateID("iq_");
         super(param1,null,param2,_loc7_,"iq");
         this.callbackName = param4;
         this.callbackScope = param5;
         this.callback = param6;
      }
      
      override public function serialize(param1:XMLNode) : Boolean
      {
         return super.serialize(param1);
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         return super.deserialize(param1);
      }
      
      public function get callback() : Function
      {
         return this.myCallbackFunc;
      }
      
      public function set callback(param1:Function) : void
      {
         this.myCallbackFunc = param1;
      }
      
      public function get callbackName() : String
      {
         return this.myCallback;
      }
      
      public function set callbackName(param1:String) : void
      {
         this.myCallback = param1;
      }
      
      public function get callbackScope() : Object
      {
         return this.myCallbackScope;
      }
      
      public function set callbackScope(param1:Object) : void
      {
         this.myCallbackScope = param1;
      }
   }
}

