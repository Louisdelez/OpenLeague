package org.igniterealtime.xiff.data.forms
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class FormExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var FIELD_TYPE_BOOLEAN:String = "boolean";
      
      public static var FIELD_TYPE_FIXED:String = "fixed";
      
      public static var FIELD_TYPE_HIDDEN:String = "hidden";
      
      public static var FIELD_TYPE_JID_MULTI:String = "jid-multi";
      
      public static var FIELD_TYPE_JID_SINGLE:String = "jid-single";
      
      public static var FIELD_TYPE_LIST_MULTI:String = "list-multi";
      
      public static var FIELD_TYPE_LIST_SINGLE:String = "list-single";
      
      public static var FIELD_TYPE_TEXT_MULTI:String = "text-multi";
      
      public static var FIELD_TYPE_TEXT_PRIVATE:String = "text-private";
      
      public static var FIELD_TYPE_TEXT_SINGLE:String = "text-single";
      
      public static var REQUEST_TYPE:String = "form";
      
      public static var RESULT_TYPE:String = "result";
      
      public static var SUBMIT_TYPE:String = "submit";
      
      public static var CANCEL_TYPE:String = "cancel";
      
      public static var NS:String = "jabber:x:data";
      
      public static var ELEMENT:String = "x";
      
      private var myItems:Array;
      
      private var myFields:Array;
      
      private var myReportedFields:Array;
      
      private var myInstructionsNode:XMLNode;
      
      private var myTitleNode:XMLNode;
      
      public function FormExtension(param1:XMLNode = null)
      {
         super(param1);
         this.myItems = new Array();
         this.myFields = new Array();
         this.myReportedFields = new Array();
      }
      
      public static function enable() : Boolean
      {
         ExtensionClassRegistry.register(FormExtension);
         return true;
      }
      
      public function getNS() : String
      {
         return FormExtension.NS;
      }
      
      public function getElementName() : String
      {
         return FormExtension.ELEMENT;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc3_:FormField = null;
         var _loc2_:XMLNode = getNode();
         for each(_loc3_ in this.myFields)
         {
            if(!_loc3_.serialize(_loc2_))
            {
               return false;
            }
         }
         if(param1 != _loc2_.parentNode)
         {
            param1.appendChild(_loc2_.cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         var _loc3_:FormField = null;
         var _loc4_:Array = null;
         var _loc5_:XMLNode = null;
         var _loc6_:XMLNode = null;
         setNode(param1);
         this.removeAllItems();
         this.removeAllFields();
         for each(_loc2_ in param1.childNodes)
         {
            switch(_loc2_.nodeName)
            {
               case "instructions":
                  this.myInstructionsNode = _loc2_;
                  break;
               case "title":
                  this.myTitleNode = _loc2_;
                  break;
               case "reported":
                  for each(_loc5_ in _loc2_.childNodes)
                  {
                     _loc3_ = new FormField();
                     _loc3_.deserialize(_loc5_);
                     this.myReportedFields.push(_loc3_);
                  }
                  break;
               case "item":
                  _loc4_ = [];
                  for each(_loc6_ in _loc2_.childNodes)
                  {
                     _loc3_ = new FormField();
                     _loc3_.deserialize(_loc6_);
                     _loc4_.push(_loc3_);
                  }
                  this.myItems.push(_loc4_);
                  break;
               case "field":
                  _loc3_ = new FormField();
                  _loc3_.deserialize(_loc2_);
                  this.myFields.push(_loc3_);
            }
         }
         return true;
      }
      
      public function getFormType() : String
      {
         var _loc1_:FormField = null;
         for each(_loc1_ in this.myFields)
         {
            if(_loc1_.name == "FORM_TYPE")
            {
               return _loc1_.value;
            }
         }
         return "";
      }
      
      public function getAllItems() : Array
      {
         return this.myItems;
      }
      
      public function getFormField(param1:String) : FormField
      {
         var _loc2_:FormField = null;
         for each(_loc2_ in this.myFields)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getAllFields() : Array
      {
         return this.myFields;
      }
      
      public function setFields(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:FormField = null;
         this.removeAllFields();
         for(_loc2_ in param1)
         {
            _loc3_ = new FormField();
            _loc3_.name = _loc2_;
            _loc3_.setAllValues(param1[_loc2_]);
            this.myFields.push(_loc3_);
         }
      }
      
      public function removeAllItems() : void
      {
         var _loc1_:FormField = null;
         var _loc2_:* = undefined;
         for each(_loc1_ in this.myItems)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.getNode().removeNode();
               _loc2_.setNode(null);
            }
         }
         this.myItems = [];
      }
      
      public function removeAllFields() : void
      {
         var _loc1_:FormField = null;
         var _loc2_:* = undefined;
         for each(_loc1_ in this.myFields)
         {
            for each(_loc2_ in _loc1_)
            {
               _loc2_.getNode().removeNode();
               _loc2_.setNode(null);
            }
         }
         this.myFields = [];
      }
      
      public function get instructions() : String
      {
         return this.myInstructionsNode.firstChild.nodeValue;
      }
      
      public function set instructions(param1:String) : void
      {
         this.myInstructionsNode = replaceTextNode(getNode(),this.myInstructionsNode,"instructions",param1);
      }
      
      public function get title() : String
      {
         return this.myTitleNode.firstChild.nodeValue;
      }
      
      public function set title(param1:String) : void
      {
         this.myTitleNode = replaceTextNode(getNode(),this.myTitleNode,"Title",param1);
      }
      
      public function getReportedFields() : Array
      {
         return this.myReportedFields;
      }
      
      public function get type() : String
      {
         return getNode().attributes.type;
      }
      
      public function set type(param1:String) : void
      {
         getNode().attributes.type = param1;
      }
   }
}

