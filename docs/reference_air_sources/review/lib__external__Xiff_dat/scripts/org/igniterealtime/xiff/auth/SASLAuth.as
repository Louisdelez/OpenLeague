package org.igniterealtime.xiff.auth
{
   import flash.xml.XMLNode;
   
   public class SASLAuth
   {
      
      protected var stage:int;
      
      protected var req:XMLNode;
      
      public function SASLAuth()
      {
         super();
      }
      
      public function get request() : XMLNode
      {
         return this.req;
      }
      
      public function handleResponse(param1:int, param2:XMLNode) : Object
      {
         throw new Error("Don\'t call this method on SASLAuth; use a subclass");
      }
   }
}

