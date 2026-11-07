package com.riotgames.platform.masteries.events
{
   import flash.events.Event;
   
   public class MasteryEvent extends Event
   {
      
      public static const MASTERY_CLICK:String = "masteryClickEvent";
      
      public static const CURRENT_PAGE_CHANGE_REQUEST:String = "currentPageChangeRequestEvent";
      
      public static const CURRENT_PAGE_CHANGED:String = "currentPageChangedEvent";
      
      public static const PAGE_DIRTY_CHANGED:String = "pageDirtyChangedEvent";
      
      public static const CREATE_PAGE_REQUEST:String = "createPageRequestEvent";
      
      public static const DELETE_PAGE_REQUEST:String = "deletePageRequestEvent";
      
      public static const REVERT_PAGE_REQUEST:String = "revertPageRequestEvent";
      
      public static const REVERT_BOOK_REQUEST:String = "revertBookRequestEvent";
      
      public static const SAVE_PAGE_REQUEST:String = "savePageRequestEvent";
      
      public static const SAVE_BOOK_REQUEST:String = "saveBookRequestEvent";
      
      public static const RETURN_POINTS_REQUEST:String = "returnPointsRequestEvent";
      
      public static const RETURN_POINTS_FOR_TREE_REQUEST:String = "returnPointsForTreeRequestEvent";
      
      public static const SAVE_BOOK_COMPLETED:String = "saveBookCompletedEvent";
      
      public static const CLOSE_EDITED_VIEW_REQUEST:String = "closeEditedViewRequestEvent";
      
      public static const GET_BOOK_REQUEST:String = "getBookRequestEvent";
      
      public var id:int;
      
      public var delta:int;
      
      public function MasteryEvent(param1:String, param2:Boolean = false, param3:Boolean = false, param4:int = 0, param5:int = 0)
      {
         super(param1,param2,param3);
         this.id = param4;
         this.delta = param5;
      }
      
      override public function clone() : Event
      {
         return new MasteryEvent(type,bubbles,cancelable,this.id,this.delta);
      }
   }
}

