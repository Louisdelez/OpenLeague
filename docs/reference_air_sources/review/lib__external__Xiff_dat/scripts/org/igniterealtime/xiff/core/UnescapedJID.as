package org.igniterealtime.xiff.core
{
   public class UnescapedJID extends AbstractJID
   {
      
      public function UnescapedJID(param1:String, param2:Boolean = false)
      {
         super(param1,param2);
         if(Boolean(node))
         {
            _node = unescapedNode(node);
         }
      }
      
      public function get escaped() : EscapedJID
      {
         return new EscapedJID(toString());
      }
      
      public function equals(param1:UnescapedJID, param2:Boolean) : Boolean
      {
         if(param2)
         {
            return param1.bareJID == bareJID;
         }
         return param1.toString() == toString();
      }
   }
}

