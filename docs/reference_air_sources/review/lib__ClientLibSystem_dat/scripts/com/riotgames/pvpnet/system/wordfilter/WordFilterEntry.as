package com.riotgames.pvpnet.system.wordfilter
{
   public class WordFilterEntry
   {
      
      public var plainText:String;
      
      public var regexText:String;
      
      public function WordFilterEntry(param1:String)
      {
         super();
         this.plainText = param1;
         this.regexText = param1.replace(new RegExp("([{}()^$&.*?/+|[\\\\]|]|-)","g"),"\\$1");
      }
   }
}

