package com.riotgames.pvpnet.tracking.trackers.itemset
{
   public interface IItemSetsOrganizationalStructureTracker
   {
      
      function setItemSets_TotalPages_Count(param1:Number) : void;
      
      function setItemSets_TotalBlocks_Count(param1:Number) : void;
      
      function setItemSets_TotalItems_Count(param1:Number) : void;
      
      function reset_recordItemSets_ChampionsAssociatedWithPage_InASession() : void;
      
      function recordItemSets_ChampionsAssociatedWithPage_InASession(param1:Number) : void;
      
      function setItemSets_MedianPageByItems_TotalGroups_Count_InASession(param1:Number) : void;
      
      function setItemSets_MedianPageByItems_TotalItems_Count_InASession(param1:Number) : void;
      
      function setItemSets_LargestPageByItems_TotalGroups_Count_InASession(param1:Number) : void;
      
      function setItemSets_LargestPageByItems_TotalItems_Count_InASession(param1:Number) : void;
      
      function setItemSets_MedianPageByGroups_TotalGroups_Count_InASession(param1:Number) : void;
      
      function setItemSets_MedianPageByGroups_TotalItems_Count_InASession(param1:Number) : void;
      
      function setItemSets_LargestPageByGroups_TotalGroups_Count_InASession(param1:Number) : void;
      
      function setItemSets_LargestPageByGroups_TotalItems_Count_InASession(param1:Number) : void;
      
      function recordItemSets_InAveragePage_Items(param1:Number) : void;
      
      function recordItemSets_InAveragePage_Groups(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage01_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage02_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage03_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage04_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage05_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage06_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage07_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage08_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage09_Count_InASession(param1:Number) : void;
      
      function setItemSets_ChampionsAssociatedWithPage10_Count_InASession(param1:Number) : void;
      
      function setAllGroupNames(param1:Array) : void;
      
      function setAllPagesNames(param1:Array) : void;
      
      function incrementItemSets_AllPages_ChampAssociationAllChampions_Count_InASession(param1:Number) : void;
      
      function incrementItemSets_AllPages_ChampAssociationOnlyOneChamp_Count_InASession(param1:Number) : void;
      
      function incrementItemSets_AllPages_ChampAssociationMoreThanOneChampButNotAll_Count_InASession(param1:Number) : void;
      
      function incrementItemSets_AllPages_MapAssociationAllMaps_Count_InASession(param1:Number) : void;
      
      function incrementItemSets_AllPages_MapAssociationOneMap_Count_InASession(param1:Number) : void;
      
      function incrementItemSets_AllPages_MapAssociationTwoMaps_Count_InASession(param1:Number) : void;
      
      function incrementItemSets_AllPages_MapAssociationThreeMaps_Count_InASession(param1:Number) : void;
      
      function setItemSets_FirstPageInDropDown_TotalGroups_Count_InASession(param1:int) : void;
      
      function setItemSets_FirstPageInDropDown_TotalItems_Count_InASession(param1:int) : void;
      
      function setItemSets_FirstPageInDropDown_TotalGoldCost_InASession(param1:int) : void;
      
      function setItemSets_MinPageByItems_TotalGroups_Count_InASession(param1:int) : void;
      
      function setItemSets_MinPageByItems_TotalItems_Count_InASession(param1:int) : void;
      
      function setItemSets_MinPageByItems_TotalGoldCost_InASession(param1:int) : void;
      
      function setItemSets_MedianPageByItems_TotalGoldCost_InASession(param1:int) : void;
      
      function setItemSets_LargestPageByItems_TotalGoldCost_InASession(param1:int) : void;
      
      function recordItemSets_InAveragePage_ItemsInGroup(param1:uint) : void;
      
      function reset_recordItemSets_InAveragePage_ItemsInGroup() : void;
      
      function reset_recordItemSets_InAveragePage_Groups() : void;
      
      function reset_recordItemSets_InAveragePage_Items() : void;
      
      function recordItemSets_InFirstPage_ItemsInGroup(param1:uint) : void;
      
      function reset_recordItemSets_InFirstPage_ItemsInGroup() : void;
      
      function recordItemSets_InMinPage_ItemsInGroup(param1:uint) : void;
      
      function reset_recordItemSets_InMinPage_ItemsInGroup() : void;
      
      function recordItemSets_InMedianPage_ItemsInGroup(param1:uint) : void;
      
      function reset_recordItemSets_InMedianPage_ItemsInGroup() : void;
      
      function recordItemSets_InMaxPage_ItemsInGroup(param1:uint) : void;
      
      function reset_recordItemSets_InMaxPage_ItemsInGroup() : void;
   }
}

