package com.riotgames.pvpnet.tracking.trackers.itemset
{
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   
   public class ItemSetsOrganizationalStructureTracker extends SessionTimeframedTracker implements IItemSetsOrganizationalStructureTracker
   {
      
      public static const ITEM_SETS__TOTAL_PAGES__COUNT:String = "item_sets__total_pages.count";
      
      public static const ITEM_SETS__TOTAL_GROUPS__COUNT:String = "item_sets__total_groups.count";
      
      public static const ITEM_SETS__TOTAL_ITEMS__COUNT:String = "item_sets__total_items.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE01___COUNT:String = "item_sets__champions_associated_with_page01.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE02___COUNT:String = "item_sets__champions_associated_with_page02.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE03___COUNT:String = "item_sets__champions_associated_with_page03.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE04___COUNT:String = "item_sets__champions_associated_with_page04.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE05___COUNT:String = "item_sets__champions_associated_with_page05.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE06___COUNT:String = "item_sets__champions_associated_with_page06.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE07___COUNT:String = "item_sets__champions_associated_with_page07.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE08___COUNT:String = "item_sets__champions_associated_with_page08.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE09___COUNT:String = "item_sets__champions_associated_with_page09.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE10___COUNT:String = "item_sets__champions_associated_with_page10.count";
      
      public static const ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_ALL_PAGES:String = "item_sets__champions_associated_with_all_pages";
      
      public static const ITEM_SETS__MEDIAN_PAGE_BY_ITEMS__TOTAL_GROUPS__COUNT:String = "item_sets__median_page_by_items__total_groups.count";
      
      public static const ITEM_SETS__MEDIAN_PAGE_BY_ITEMS__TOTAL_ITEMS__COUNT:String = "item_sets__median_page_by_items__total_items.count";
      
      public static const ITEM_SETS__LARGEST_PAGE_BY_ITEMS__TOTAL_GROUPS__COUNT:String = "item_sets__largest_page_by_items__total_groups.count";
      
      public static const ITEM_SETS__LARGEST_PAGE_BY_ITEMS__TOTAL_ITEMS__COUNT:String = "item_sets__largest_page_by_items__total_items.count";
      
      public static const ITEM_SETS__MEDIAN_PAGE_BY_GROUPS__TOTAL_GROUPS__COUNT:String = "item_sets__median_page_by_groups__total_groups.count";
      
      public static const ITEM_SETS__MEDIAN_PAGE_BY_GROUPS__TOTAL_ITEMS__COUNT:String = "item_sets__median_page_by_groups__total_items.count";
      
      public static const ITEM_SETS__LARGEST_PAGE_BY_GROUPS__TOTAL_GROUPS__COUNT:String = "item_sets__largest_page_by_groups__total_groups.count";
      
      public static const ITEM_SETS__LARGEST_PAGE_BY_GROUPS__TOTAL_ITEMS__COUNT:String = "item_sets__largest_page_by_groups__total_items.count";
      
      public static const ITEM_SETS__IN_AVERAGE_PAGE__ITEMS:String = "item_sets__in_average_page__items";
      
      public static const ITEM_SETS__IN_AVERAGE_PAGE__GROUPS:String = "item_sets__in_average_page__groups";
      
      public static const ITEM_SETS__PAGE_NAMES:String = "item_sets__page_names";
      
      public static const ITEM_SETS__ALL__GROUPS__NAMES:String = "item_sets__all_groups__names";
      
      public static const ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ALL_CHAMPIONS__COUNT:String = "item_sets__all_pages__champ_association_all_champions.count";
      
      public static const ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ALL_CHAMPIONS__PERCENTAGE:String = "item_sets__all_pages__champ_association_all_champions.percentage";
      
      public static const ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ONLY_ONE_CHAMP__COUNT:String = "item_sets__all_pages__champ_association_only_one_champ.count";
      
      public static const ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ONLY_ONE_CHAMP__PERCENTAGE:String = "item_sets__all_pages__champ_association_only_one_champ.percentage";
      
      public static const ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_MORE_THAN_ONE_CHAMP_BUT_NOT_ALL__COUNT:String = "item_sets__all_pages__champ_association_more_than_one_champ_but_not_all.count";
      
      public static const ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_MORE_THAN_ONE_CHAMP_BUT_NOT_ALL__PERCENTAGE:String = "item_sets__all_pages__champ_association_more_than_one_champ_but_not_all.percentage";
      
      public static const ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ALL_MAPS__COUNT:String = "item_sets__all_pages__map_association_all_maps.count";
      
      public static const ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ALL_MAPS__PERCENTAGE:String = "item_sets__all_pages__map_association_all_maps.percentage";
      
      public static const ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ONE_MAP__COUNT:String = "item_sets__all_pages__map_association_one_map.count";
      
      public static const ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ONE_MAP__PERCENTAGE:String = "item_sets__all_pages__map_association_one_map.percentage";
      
      public static const ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_TWO_MAPS__COUNT:String = "item_sets__all_pages__map_association_two_maps.count";
      
      public static const ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_TWO_MAPS__PERCENTAGE:String = "item_sets__all_pages__map_association_two_maps.percentage";
      
      public static const ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_THREE_MAPS__COUNT:String = "item_sets__all_pages__map_association_three_maps.count";
      
      public static const ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_THREE_MAPS__PERCENTAGE:String = "item_sets__all_pages__map_association_three_maps.percentage";
      
      public static const ITEM_SETS__FIRST_PAGE_IN_DROP_DOWN__TOTAL_GROUPS__COUNT:String = "item_sets__first_page_in_drop_down__total_groups.count";
      
      public static const ITEM_SETS__FIRST_PAGE_IN_DROP_DOWN__TOTAL_ITEMS__COUNT:String = "item_sets__first_page_in_drop_down__total_items.count";
      
      public static const ITEM_SETS__FIRST_PAGE_IN_DROP_DOWN__TOTAL_GOLD__COST:String = "item_sets__first_page_in_drop_down__total_gold__cost";
      
      public static const ITEM_SETS__MIN_PAGE_BY_ITEMS__TOTAL_GROUPS__COUNT:String = "item_sets__min_page_by_items__total_groups.count";
      
      public static const ITEM_SETS__MIN_PAGE_BY_ITEMS__TOTAL_ITEMS__COUNT:String = "item_sets__min_page_by_items__total_items.count";
      
      public static const ITEM_SETS__MIN_PAGE_BY_ITEMS__TOTAL_GOLD__COST:String = "item_sets__min_page_by_items__total_gold__cost";
      
      public static const ITEM_SETS__MEDIAN_PAGE_BY_ITEMS__TOTAL_GOLD__COST:String = "item_sets__median_page_by_items__total_gold__cost";
      
      public static const ITEM_SETS__LARGEST_PAGE_BY_ITEMS__TOTAL_GOLD__COST:String = "item_sets__largest_page_by_items__total_gold__cost";
      
      public static const ITEM_SETS__IN_AVERAGE_PAGE__ITEMS_IN_GROUP:String = "item_sets__in_average_page__items_in_group";
      
      public static const ITEM_SETS__IN_FIRST_PAGE__ITEMS_IN_GROUP:String = "item_sets__in_first_page__items_in_group";
      
      public static const ITEM_SETS__IN_MIN_PAGE__ITEMS_IN_GROUP:String = "item_sets__in_min_page__items_in_group";
      
      public static const ITEM_SETS__IN_MEDIAN_PAGE__ITEMS_IN_GROUP:String = "item_sets__in_median_page__items_in_group";
      
      public static const ITEM_SETS__IN_MAX_PAGE__ITEMS_IN_GROUP:String = "item_sets__in_max_page__items_in_group";
      
      public var hasblocks:Object = new Object();
      
      public function ItemSetsOrganizationalStructureTracker(param1:Boolean = true)
      {
         super("item_sets_organizational_structure",param1);
         isTimer = false;
      }
      
      public function reset_recordItemSets_InMedianPage_ItemsInGroup() : void
      {
         if(hasRecording(ITEM_SETS__IN_MEDIAN_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_MEDIAN_PAGE__ITEMS_IN_GROUP).reset();
         }
      }
      
      public function reset_recordItemSets_InAveragePage_Groups() : void
      {
         if(hasRecording(ITEM_SETS__IN_AVERAGE_PAGE__GROUPS))
         {
            getRecording(ITEM_SETS__IN_AVERAGE_PAGE__GROUPS).reset();
         }
      }
      
      public function recordItemSets_InMinPage_ItemsInGroup(param1:uint) : void
      {
         recordValue(ITEM_SETS__IN_MIN_PAGE__ITEMS_IN_GROUP,param1);
      }
      
      public function setItemSets_MinPageByItems_TotalGroups_Count_InASession(param1:int) : void
      {
         setCounterValue(ITEM_SETS__MIN_PAGE_BY_ITEMS__TOTAL_GROUPS__COUNT,param1);
      }
      
      public function recordItemSets_InMedianPage_ItemsInGroup(param1:uint) : void
      {
         recordValue(ITEM_SETS__IN_MEDIAN_PAGE__ITEMS_IN_GROUP,param1);
      }
      
      public function setItemSets_LargestPageByItems_TotalGoldCost_InASession(param1:int) : void
      {
         setCounterValue(ITEM_SETS__LARGEST_PAGE_BY_ITEMS__TOTAL_GOLD__COST,param1);
      }
      
      public function reset_recordItemSets_InMinPage_ItemsInGroup() : void
      {
         if(hasRecording(ITEM_SETS__IN_MIN_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_MIN_PAGE__ITEMS_IN_GROUP).reset();
         }
      }
      
      public function setItemSets_ChampionsAssociatedWithPage05_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE05___COUNT,param1);
      }
      
      public function setItemSets_LargestPageByItems_TotalGroups_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__LARGEST_PAGE_BY_ITEMS__TOTAL_GROUPS__COUNT,param1);
      }
      
      public function recordItemSets_InAveragePage_ItemsInGroup(param1:uint) : void
      {
         recordValue(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS_IN_GROUP,param1);
      }
      
      public function setItemSets_MedianPageByItems_TotalGroups_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__MEDIAN_PAGE_BY_ITEMS__TOTAL_GROUPS__COUNT,param1);
      }
      
      public function setAllPagesNames(param1:Array) : void
      {
         setProperty(ITEM_SETS__PAGE_NAMES,param1.join(";"));
      }
      
      public function reset_recordItemSets_InAveragePage_ItemsInGroup() : void
      {
         if(hasRecording(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS_IN_GROUP).reset();
         }
      }
      
      public function incrementItemSets_AllPages_MapAssociationThreeMaps_Count_InASession(param1:Number) : void
      {
         incrementCounter(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_THREE_MAPS__COUNT);
         var _loc2_:Number = Number(getCounterValue(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_THREE_MAPS__COUNT));
         setCounterValue(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_THREE_MAPS__PERCENTAGE,_loc2_ / param1);
      }
      
      public function recordItemSets_InMaxPage_ItemsInGroup(param1:uint) : void
      {
         recordValue(ITEM_SETS__IN_MAX_PAGE__ITEMS_IN_GROUP,param1);
      }
      
      public function setItemSets_ChampionsAssociatedWithPage10_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE10___COUNT,param1);
      }
      
      public function setItemSets_ChampionsAssociatedWithPage06_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE06___COUNT,param1);
      }
      
      public function setAllGroupNames(param1:Array) : void
      {
         setProperty(ITEM_SETS__ALL__GROUPS__NAMES,param1.join(";"));
      }
      
      public function reset_recordItemSets_InMaxPage_ItemsInGroup() : void
      {
         if(hasRecording(ITEM_SETS__IN_MAX_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_MAX_PAGE__ITEMS_IN_GROUP).reset();
         }
      }
      
      public function incrementItemSets_AllPages_MapAssociationAllMaps_Count_InASession(param1:Number) : void
      {
         incrementCounter(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ALL_MAPS__COUNT);
         var _loc2_:Number = Number(getCounterValue(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ALL_MAPS__COUNT));
         setCounterValue(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ALL_MAPS__PERCENTAGE,_loc2_ / param1);
      }
      
      public function reset_recordItemSets_InAveragePage_Items() : void
      {
         if(hasRecording(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS))
         {
            getRecording(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS).reset();
         }
      }
      
      public function incrementItemSets_AllPages_ChampAssociationOnlyOneChamp_Count_InASession(param1:Number) : void
      {
         incrementCounter(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ONLY_ONE_CHAMP__COUNT);
         var _loc2_:Number = Number(getCounterValue(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ONLY_ONE_CHAMP__COUNT));
         setCounterValue(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ONLY_ONE_CHAMP__PERCENTAGE,_loc2_ / param1);
      }
      
      public function setItemSets_ChampionsAssociatedWithPage07_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE07___COUNT,param1);
      }
      
      public function recordItemSets_InAveragePage_Items(param1:Number) : void
      {
         recordValue(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS,param1);
      }
      
      public function setItemSets_MedianPageByItems_TotalItems_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__MEDIAN_PAGE_BY_ITEMS__TOTAL_ITEMS__COUNT,param1);
      }
      
      public function setItemSets_FirstPageInDropDown_TotalGroups_Count_InASession(param1:int) : void
      {
         setCounterValue(ITEM_SETS__FIRST_PAGE_IN_DROP_DOWN__TOTAL_GROUPS__COUNT,param1);
      }
      
      public function setItemSets_ChampionsAssociatedWithPage08_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE08___COUNT,param1);
      }
      
      public function setItemSets_LargestPageByItems_TotalItems_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__LARGEST_PAGE_BY_ITEMS__TOTAL_ITEMS__COUNT,param1);
      }
      
      public function incrementItemSets_AllPages_MapAssociationTwoMaps_Count_InASession(param1:Number) : void
      {
         incrementCounter(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_TWO_MAPS__COUNT);
         var _loc2_:Number = Number(getCounterValue(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_TWO_MAPS__COUNT));
         setCounterValue(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_TWO_MAPS__PERCENTAGE,_loc2_ / param1);
      }
      
      public function setItemSets_TotalItems_Count(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__TOTAL_ITEMS__COUNT,param1);
      }
      
      public function setItemSets_TotalPages_Count(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__TOTAL_PAGES__COUNT,param1);
      }
      
      public function incrementItemSets_AllPages_ChampAssociationAllChampions_Count_InASession(param1:Number) : void
      {
         incrementCounter(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ALL_CHAMPIONS__COUNT);
         var _loc2_:Number = Number(getCounterValue(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ALL_CHAMPIONS__COUNT));
         setCounterValue(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_ALL_CHAMPIONS__PERCENTAGE,_loc2_ / param1);
      }
      
      public function setItemSets_MedianPageByGroups_TotalGroups_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__MEDIAN_PAGE_BY_GROUPS__TOTAL_GROUPS__COUNT,param1);
      }
      
      public function setItemSets_ChampionsAssociatedWithPage09_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE09___COUNT,param1);
      }
      
      public function setItemSets_ChampionsAssociatedWithPage01_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE01___COUNT,param1);
      }
      
      public function recordItemSets_ChampionsAssociatedWithPage_InASession(param1:Number) : void
      {
         recordValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_ALL_PAGES,param1);
      }
      
      override public function sessionClosed() : void
      {
         if(hasRecording(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS))
         {
            getRecording(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__IN_AVERAGE_PAGE__GROUPS))
         {
            getRecording(ITEM_SETS__IN_AVERAGE_PAGE__GROUPS).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_ALL_PAGES))
         {
            getRecording(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_ALL_PAGES).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_AVERAGE_PAGE__ITEMS_IN_GROUP).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__IN_FIRST_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_FIRST_PAGE__ITEMS_IN_GROUP).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__IN_MIN_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_MIN_PAGE__ITEMS_IN_GROUP).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__IN_MEDIAN_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_MEDIAN_PAGE__ITEMS_IN_GROUP).appendParentName = false;
         }
         if(hasRecording(ITEM_SETS__IN_MAX_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_MAX_PAGE__ITEMS_IN_GROUP).appendParentName = false;
         }
         super.sessionClosed();
      }
      
      public function recordItemSets_InFirstPage_ItemsInGroup(param1:uint) : void
      {
         recordValue(ITEM_SETS__IN_FIRST_PAGE__ITEMS_IN_GROUP,param1);
      }
      
      public function setItemSets_FirstPageInDropDown_TotalItems_Count_InASession(param1:int) : void
      {
         setCounterValue(ITEM_SETS__FIRST_PAGE_IN_DROP_DOWN__TOTAL_ITEMS__COUNT,param1);
      }
      
      public function reset_recordItemSets_ChampionsAssociatedWithPage_InASession() : void
      {
         if(hasRecording(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_ALL_PAGES))
         {
            getRecording(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_ALL_PAGES).reset();
         }
      }
      
      public function setItemSets_MinPageByItems_TotalItems_Count_InASession(param1:int) : void
      {
         setCounterValue(ITEM_SETS__MIN_PAGE_BY_ITEMS__TOTAL_ITEMS__COUNT,param1);
      }
      
      public function setItemSets_LargestPageByGroups_TotalItems_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__LARGEST_PAGE_BY_GROUPS__TOTAL_ITEMS__COUNT,param1);
      }
      
      public function incrementItemSets_AllPages_ChampAssociationMoreThanOneChampButNotAll_Count_InASession(param1:Number) : void
      {
         incrementCounter(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_MORE_THAN_ONE_CHAMP_BUT_NOT_ALL__COUNT);
         var _loc2_:Number = Number(getCounterValue(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_MORE_THAN_ONE_CHAMP_BUT_NOT_ALL__COUNT));
         setCounterValue(ITEM_SETS__ALL_PAGES__CHAMP_ASSOCIATION_MORE_THAN_ONE_CHAMP_BUT_NOT_ALL__PERCENTAGE,_loc2_ / param1);
      }
      
      public function reset_recordItemSets_InFirstPage_ItemsInGroup() : void
      {
         if(hasRecording(ITEM_SETS__IN_FIRST_PAGE__ITEMS_IN_GROUP))
         {
            getRecording(ITEM_SETS__IN_FIRST_PAGE__ITEMS_IN_GROUP).reset();
         }
      }
      
      public function setItemSets_ChampionsAssociatedWithPage02_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE02___COUNT,param1);
      }
      
      public function setItemSets_LargestPageByGroups_TotalGroups_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__LARGEST_PAGE_BY_GROUPS__TOTAL_GROUPS__COUNT,param1);
      }
      
      public function setItemSets_TotalBlocks_Count(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__TOTAL_GROUPS__COUNT,param1);
      }
      
      public function setItemSets_MedianPageByGroups_TotalItems_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__MEDIAN_PAGE_BY_GROUPS__TOTAL_ITEMS__COUNT,param1);
      }
      
      public function setItemSets_FirstPageInDropDown_TotalGoldCost_InASession(param1:int) : void
      {
         setCounterValue(ITEM_SETS__FIRST_PAGE_IN_DROP_DOWN__TOTAL_GOLD__COST,param1);
      }
      
      public function setItemSets_ChampionsAssociatedWithPage03_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE03___COUNT,param1);
      }
      
      public function setItemSets_MinPageByItems_TotalGoldCost_InASession(param1:int) : void
      {
         setCounterValue(ITEM_SETS__MIN_PAGE_BY_ITEMS__TOTAL_GOLD__COST,param1);
      }
      
      public function recordItemSets_InAveragePage_Groups(param1:Number) : void
      {
         recordValue(ITEM_SETS__IN_AVERAGE_PAGE__GROUPS,param1);
      }
      
      public function setItemSets_MedianPageByItems_TotalGoldCost_InASession(param1:int) : void
      {
         setCounterValue(ITEM_SETS__MEDIAN_PAGE_BY_ITEMS__TOTAL_GOLD__COST,param1);
      }
      
      public function setItemSets_ChampionsAssociatedWithPage04_Count_InASession(param1:Number) : void
      {
         setCounterValue(ITEM_SETS__CHAMPIONS_ASSOCIATED_WITH_PAGE04___COUNT,param1);
      }
      
      public function incrementItemSets_AllPages_MapAssociationOneMap_Count_InASession(param1:Number) : void
      {
         incrementCounter(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ONE_MAP__COUNT);
         var _loc2_:Number = Number(getCounterValue(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ONE_MAP__COUNT));
         setCounterValue(ITEM_SETS__ALL_PAGES__MAP_ASSOCIATION_ONE_MAP__PERCENTAGE,_loc2_ / param1);
      }
   }
}

