package
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.ratings.RatingsPopup;
   import flash.display.Sprite;
   import mx.binding.IWatcherSetupUtil;
   import mx.binding.StaticPropertyWatcher;
   import mx.core.IFlexModuleFactory;
   
   public class _com_riotgames_platform_common_ratings_RatingsPopupWatcherSetupUtil extends Sprite implements IWatcherSetupUtil
   {
      
      public function _com_riotgames_platform_common_ratings_RatingsPopupWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RatingsPopup.watcherSetupUtil = new _com_riotgames_platform_common_ratings_RatingsPopupWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Array, param4:Array) : void
      {
         param4[0] = new StaticPropertyWatcher("instance",null,[param3[0]],null);
         param4[0].updateParent(ImagePackLookup);
      }
   }
}

