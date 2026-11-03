package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.id.IIDGenerator;
   import org.igniterealtime.xiff.data.id.IncrementalGenerator;
   
   public dynamic class XMPPStanza extends XMLStanza implements ISerializable, IExtendable
   {
      
      public static var CLIENT_NS:String = "jabber:client";
      
      private static var staticDependencies:* = [IncrementalGenerator,ExtensionContainer];
      
      private static var isStaticConstructed:* = XMPPStanzaStaticConstructor();
      
      private var myErrorNode:XMLNode;
      
      private var myErrorConditionNode:XMLNode;
      
      public function XMPPStanza(param1:EscapedJID, param2:EscapedJID, param3:String, param4:String, param5:String)
      {
         super();
         getNode().nodeName = param5;
         this.to = param1;
         this.from = param2;
         this.type = param3;
         this.id = param4;
      }
      
      private static function XMPPStanzaStaticConstructor() : void
      {
      }
      
      public static function generateID(param1:String) : String
      {
         return IncrementalGenerator.getInstance().getID(param1);
      }
      
      public static function setIDGenerator(param1:IIDGenerator) : void
      {
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc4_:ISerializable = null;
         var _loc2_:XMLNode = getNode();
         var _loc3_:Array = getAllExtensions();
         for each(_loc4_ in _loc3_)
         {
            _loc4_.serialize(_loc2_);
         }
         if(!exists(_loc2_.parentNode))
         {
            _loc2_ = _loc2_.cloneNode(true);
            param1.appendChild(_loc2_);
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Class = null;
         var _loc7_:IExtension = null;
         setNode(param1);
         var _loc2_:Array = param1.childNodes;
         for(_loc3_ in _loc2_)
         {
            _loc4_ = _loc2_[_loc3_].nodeName;
            _loc5_ = _loc2_[_loc3_].attributes.xmlns;
            _loc5_ = exists(_loc5_) ? _loc5_ : CLIENT_NS;
            if(_loc4_ == "error")
            {
               this.myErrorNode = _loc2_[_loc3_];
               if(exists(this.myErrorNode.firstChild.nodeName))
               {
                  this.myErrorConditionNode = this.myErrorNode.firstChild;
               }
            }
            else
            {
               _loc6_ = ExtensionClassRegistry.lookup(_loc5_);
               if(_loc6_ != null)
               {
                  _loc7_ = new _loc6_();
                  ISerializable(_loc7_).deserialize(_loc2_[_loc3_]);
                  addExtension(_loc7_);
               }
            }
         }
         return true;
      }
      
      public function get to() : EscapedJID
      {
         return new EscapedJID(getNode().attributes.to);
      }
      
      public function set to(param1:EscapedJID) : void
      {
         delete getNode().attributes.to;
         if(exists(param1))
         {
            getNode().attributes.to = param1.toString();
         }
      }
      
      public function get from() : EscapedJID
      {
         return new EscapedJID(getNode().attributes.from);
      }
      
      public function set from(param1:EscapedJID) : void
      {
         delete getNode().attributes.from;
         if(exists(param1))
         {
            getNode().attributes.from = param1.toString();
         }
      }
      
      public function get type() : String
      {
         return getNode().attributes.type;
      }
      
      public function set type(param1:String) : void
      {
         delete getNode().attributes.type;
         if(exists(param1))
         {
            getNode().attributes.type = param1;
         }
      }
      
      public function get id() : String
      {
         return getNode().attributes.id;
      }
      
      public function set id(param1:String) : void
      {
         delete getNode().attributes.id;
         if(exists(param1))
         {
            getNode().attributes.id = param1;
         }
      }
      
      public function get errorMessage() : String
      {
         if(exists(this.errorCondition))
         {
            return this.errorCondition.toString();
         }
         return this.myErrorNode.firstChild.nodeValue;
      }
      
      public function set errorMessage(param1:String) : void
      {
         var _loc2_:Object = null;
         this.myErrorNode = ensureNode(this.myErrorNode,"error");
         param1 = exists(param1) ? param1 : "";
         if(exists(this.errorCondition))
         {
            this.myErrorConditionNode = replaceTextNode(this.myErrorNode,this.myErrorConditionNode,this.errorCondition,param1);
         }
         else
         {
            _loc2_ = this.myErrorNode.attributes;
            this.myErrorNode = replaceTextNode(getNode(),this.myErrorNode,"error",param1);
            this.myErrorNode.attributes = _loc2_;
         }
      }
      
      public function get errorCondition() : String
      {
         if(exists(this.myErrorConditionNode))
         {
            return this.myErrorConditionNode.nodeName;
         }
         return null;
      }
      
      public function set errorCondition(param1:String) : void
      {
         this.myErrorNode = ensureNode(this.myErrorNode,"error");
         var _loc2_:Object = this.myErrorNode.attributes;
         var _loc3_:String = this.errorMessage;
         if(exists(param1))
         {
            this.myErrorNode = replaceTextNode(getNode(),this.myErrorNode,"error","");
            this.myErrorConditionNode = addTextNode(this.myErrorNode,param1,_loc3_);
         }
         else
         {
            this.myErrorNode = replaceTextNode(getNode(),this.myErrorNode,"error",_loc3_);
         }
         this.myErrorNode.attributes = _loc2_;
      }
      
      public function get errorType() : String
      {
         return this.myErrorNode.attributes.type;
      }
      
      public function set errorType(param1:String) : void
      {
         this.myErrorNode = ensureNode(this.myErrorNode,"error");
         delete this.myErrorNode.attributes.type;
         if(exists(param1))
         {
            this.myErrorNode.attributes.type = param1;
         }
      }
      
      public function get errorCode() : Number
      {
         return Number(this.myErrorNode.attributes.code);
      }
      
      public function set errorCode(param1:Number) : void
      {
         this.myErrorNode = ensureNode(this.myErrorNode,"error");
         delete this.myErrorNode.attributes.code;
         if(exists(param1))
         {
            this.myErrorNode.attributes.code = param1;
         }
      }
   }
}

