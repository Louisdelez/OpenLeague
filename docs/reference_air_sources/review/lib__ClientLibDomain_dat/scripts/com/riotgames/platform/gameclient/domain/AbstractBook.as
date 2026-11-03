package com.riotgames.platform.gameclient.domain
{
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   
   public class AbstractBook extends AbstractDomainObject
   {
      
      public static const PAGE_NAME_TOKEN:String = "@@!PaG3!@@";
      
      public var sortByPageId:Sort;
      
      public var summonerId:Number;
      
      protected var _bookPages:ArrayCollection;
      
      public var dateString:String;
      
      public function AbstractBook()
      {
         super();
         this.sortByPageId = new Sort();
         this.sortByPageId.fields = [new SortField("pageId")];
      }
   }
}

