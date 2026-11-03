package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   
   public class AbstractExtension extends Extension implements ISerializable
   {
      
      public function AbstractExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = getNode().cloneNode(true);
         var _loc3_:Array = getAllExtensions();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            if(_loc3_[_loc4_] is ISerializable)
            {
               ISerializable(_loc3_[_loc4_]).serialize(_loc2_);
            }
            _loc4_++;
         }
         param1.appendChild(_loc2_);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         var _loc3_:Class = null;
         var _loc4_:IExtension = null;
         setNode(param1);
         for each(_loc2_ in param1.childNodes)
         {
            _loc3_ = ExtensionClassRegistry.lookup(_loc2_.attributes.xmlns);
            if(_loc3_ != null)
            {
               _loc4_ = new _loc3_();
               if(_loc4_ != null)
               {
                  if(_loc4_ is ISerializable)
                  {
                     ISerializable(_loc4_).deserialize(_loc2_);
                  }
                  addExtension(_loc4_);
               }
            }
         }
         return true;
      }
   }
}

