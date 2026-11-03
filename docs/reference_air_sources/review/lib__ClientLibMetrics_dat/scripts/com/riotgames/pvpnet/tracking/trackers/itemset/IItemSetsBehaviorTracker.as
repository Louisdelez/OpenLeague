package com.riotgames.pvpnet.tracking.trackers.itemset
{
   public interface IItemSetsBehaviorTracker
   {
      
      function incrementItemSets_PagesCreated_Count_InASession() : void;
      
      function incrementItemSets_PagesRenamed_Count_InASession() : void;
      
      function incrementItemSets_PagesUpdatedContents_Count_InASession() : void;
      
      function incrementItemSets_PagesDeleted_Count_InASession() : void;
      
      function incrementItemSets_AllPagesReverted_Count_InASession() : void;
      
      function incrementItemSets_UserSwitchedActiveItemSet_Count_InASession() : void;
      
      function incrementItemSets_BlocksCreated_Count_InASession() : void;
      
      function incrementItemSets_BlocksRenamed_Count_InASession() : void;
      
      function incrementItemSets_BlocksMoved_Count_InASession() : void;
      
      function incrementItemSets_BlocksDeleted_Count_InASession() : void;
      
      function incrementItemSets_BlocksHadItemAddedToContents_Count_InASession() : void;
      
      function incrementItemSets_BlocksHadItemRemovedFromContents_Count_InASession() : void;
      
      function incrementItemSets_BlocksUpdatedContents_Count_InASession() : void;
      
      function incrementItemSets_AddItemToBlockAtBeginning_Count_InASession() : void;
      
      function incrementItemSets_AddItemToBlockAtMiddle_Count_InASession() : void;
      
      function incrementItemSets_AddItemToBlockAtEnd_Count_InASession() : void;
      
      function incrementItemSets_PageVisits_WithCreation_Count_InASession() : void;
      
      function incrementItemSets_PageVisits_WithoutCreation_Count_InASession() : void;
      
      function incrementItemSets_PageVisits_Total_Count_InASession() : void;
      
      function recordItemSets_PageVisits_WithUpdatesDuration(param1:Number) : void;
      
      function recordItemSets_PageVisits_WithoutUpdatesDuration(param1:Number) : void;
      
      function recordItemSets_PageVisits_TotalDuration(param1:Number) : void;
      
      function incrementItemSets_PageVisits_Navigation_ViaItemTree_Count_InASession(param1:String) : void;
      
      function incrementItemSets_PageVisits_Navigation_ViaCategoriesList_Count_InASession() : void;
      
      function incrementItemSets_UserSwitchedToItemBrowserFromItemDetail_Count_InASession() : void;
      
      function incrementItemSets_UserSwitchedToItemDetailFromItemBrowser_Count_InASession(param1:String) : void;
      
      function incrementItemSets_UserItemSearchBarUsed_Count_InASession() : void;
      
      function incrementItemSets_UserDragAndDropSuccess_Count_InASession() : void;
      
      function incrementItemSets_UserDragAndDropFailure_Count_InASession() : void;
      
      function incrementItemSets_UserDragAndDropTotal_Count_InASession() : void;
      
      function incrementItemSets_UserLeftClicked_Count_InASession() : void;
      
      function incrementItemSets_UserRightClicked_Count_InASession() : void;
      
      function incrementItemSets_UserDoubleClicked_Count_InASession() : void;
      
      function incrementItemSets_UserMouseInteractedWithItemSet_Count_InASession() : void;
      
      function incrementItemSets_UserCategoryFilterCheckboxClicked_Count_InASession() : void;
      
      function incrementItemSets_UserCategoryActualNameClicked_Count_InASession() : void;
      
      function startItemSets_PageVisit() : void;
      
      function stopItemSets_PageVisit() : void;
   }
}

