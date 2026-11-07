package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtendable;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class MUCBaseExtension extends Extension implements IExtendable, ISerializable
   {
      
      private var myItems:Array = [];
      
      public function MUCBaseExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         var _loc2_:XMLNode = getNode();
         for each(_loc3_ in this.myItems)
         {
            if(!_loc3_.serialize(_loc2_))
            {
               return false;
            }
         }
         _loc4_ = getAllExtensions();
         for each(_loc5_ in _loc4_)
         {
            if(!_loc5_.serialize(_loc2_))
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
         var _loc3_:MUCItem = null;
         var _loc4_:Class = null;
         var _loc5_:IExtension = null;
         setNode(param1);
         this.removeAllItems();
         for each(_loc2_ in param1.childNodes)
         {
            switch(_loc2_.nodeName)
            {
               case "item":
                  _loc3_ = new MUCItem(getNode());
                  _loc3_.deserialize(_loc2_);
                  this.myItems.push(_loc3_);
                  break;
               default:
                  _loc4_ = ExtensionClassRegistry.lookup(_loc2_.attributes.xmlns);
                  if(_loc4_ != null)
                  {
                     _loc5_ = new _loc4_();
                     if(_loc5_ != null)
                     {
                        if(_loc5_ is ISerializable)
                        {
                           ISerializable(_loc5_).deserialize(_loc2_);
                        }
                        addExtension(_loc5_);
                     }
                  }
            }
         }
         return true;
      }
      
      public function getAllItems() : Array
      {
         return this.myItems;
      }
      
      public function addItem(param1:String = null, param2:String = null, param3:String = null, param4:EscapedJID = null, param5:String = null, param6:String = null) : MUCItem
      {
         var _loc7_:MUCItem = new MUCItem(getNode());
         if(exists(param1))
         {
            _loc7_.affiliation = param1;
         }
         if(exists(param2))
         {
            _loc7_.role = param2;
         }
         if(exists(param3))
         {
            _loc7_.nick = param3;
         }
         if(exists(param4))
         {
            _loc7_.jid = param4;
         }
         if(exists(param5))
         {
            _loc7_.actor = new EscapedJID(param5);
         }
         if(exists(param6))
         {
            _loc7_.reason = param6;
         }
         this.myItems.push(_loc7_);
         return _loc7_;
      }
      
      public function removeAllItems() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this.myItems)
         {
            _loc1_.setNode(null);
         }
         this.myItems = [];
      }
   }
}

