package org.igniterealtime.xiff.data.forms
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class FormField extends XMLStanza implements ISerializable
   {
      
      public static var ELEMENT:String = "field";
      
      private var myDescNode:XMLNode;
      
      private var myRequiredNode:XMLNode;
      
      private var myValueNodes:Array;
      
      private var myOptionNodes:Array;
      
      public function FormField()
      {
         super();
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         getNode().nodeName = FormField.ELEMENT;
         if(param1 != getNode().parentNode)
         {
            param1.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:XMLNode = null;
         setNode(param1);
         this.myValueNodes = new Array();
         this.myOptionNodes = new Array();
         var _loc2_:Array = param1.childNodes;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = _loc2_[_loc3_];
            switch(_loc2_[_loc3_].nodeName)
            {
               case "desc":
                  this.myDescNode = _loc4_;
                  break;
               case "required":
                  this.myRequiredNode = _loc4_;
                  break;
               case "value":
                  this.myValueNodes.push(_loc4_);
                  break;
               case "option":
                  this.myOptionNodes.push(_loc4_);
            }
         }
         return true;
      }
      
      public function get name() : String
      {
         return getNode().attributes["var"];
      }
      
      public function set name(param1:String) : void
      {
         getNode().attributes["var"] = param1;
      }
      
      public function get type() : String
      {
         return getNode().attributes.type;
      }
      
      public function set type(param1:String) : void
      {
         getNode().attributes.type = param1;
      }
      
      public function get label() : String
      {
         return getNode().attributes.label;
      }
      
      public function set label(param1:String) : void
      {
         getNode().attributes.label = param1;
      }
      
      public function get value() : String
      {
         try
         {
            if(this.myValueNodes[0] != null && this.myValueNodes[0].firstChild != null)
            {
               return this.myValueNodes[0].firstChild.nodeValue;
            }
         }
         catch(error:Error)
         {
         }
         return null;
      }
      
      public function set value(param1:String) : void
      {
         if(this.myValueNodes == null)
         {
            this.myValueNodes = new Array();
         }
         this.myValueNodes[0] = replaceTextNode(getNode(),this.myValueNodes[0],"value",param1);
      }
      
      public function getAllValues() : Array
      {
         var _loc2_:XMLNode = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.myValueNodes)
         {
            _loc1_.push(_loc2_.firstChild.nodeValue);
         }
         return _loc1_;
      }
      
      public function setAllValues(param1:Array) : void
      {
         var v:XMLNode = null;
         var val:Array = param1;
         for each(v in this.myValueNodes)
         {
            v.removeNode();
         }
         this.myValueNodes = val.map(function(param1:String, param2:uint, param3:Array):*
         {
            return replaceTextNode(getNode(),undefined,"value",param1);
         });
      }
      
      public function getAllOptions() : Array
      {
         return this.myOptionNodes.map(function(param1:XMLNode, param2:uint, param3:Array):Object
         {
            return {
               "label":param1.attributes.label,
               "value":param1.firstChild.firstChild.nodeValue
            };
         });
      }
      
      public function setAllOptions(param1:Array) : void
      {
         var optionNode:XMLNode = null;
         var val:Array = param1;
         for each(optionNode in this.myOptionNodes)
         {
            optionNode.removeNode();
         }
         this.myOptionNodes = val.map(function(param1:Object, param2:uint, param3:Array):XMLNode
         {
            var _loc4_:* = replaceTextNode(getNode(),undefined,"value",param1.value);
            _loc4_.attributes.label = param1.label;
            return _loc4_;
         });
      }
   }
}

