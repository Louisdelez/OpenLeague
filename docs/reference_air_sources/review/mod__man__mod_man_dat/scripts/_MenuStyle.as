package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.ListDropIndicator;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _MenuStyle
   {
      
      private static var _embed_css_Assets_swf_MenuCheckEnabled_620306124:Class = _MenuStyle__embed_css_Assets_swf_MenuCheckEnabled_620306124;
      
      private static var _embed_css_Assets_swf_MenuCheckDisabled_963333585:Class = _MenuStyle__embed_css_Assets_swf_MenuCheckDisabled_963333585;
      
      private static var _embed_css_Assets_swf_MenuBranchEnabled_1304847660:Class = _MenuStyle__embed_css_Assets_swf_MenuBranchEnabled_1304847660;
      
      private static var _embed_css_Assets_swf_MenuSeparator_1504191214:Class = _MenuStyle__embed_css_Assets_swf_MenuSeparator_1504191214;
      
      private static var _embed_css_Assets_swf_MenuRadioEnabled_1493941841:Class = _MenuStyle__embed_css_Assets_swf_MenuRadioEnabled_1493941841;
      
      private static var _embed_css_Assets_swf_MenuRadioDisabled_79943404:Class = _MenuStyle__embed_css_Assets_swf_MenuRadioDisabled_79943404;
      
      private static var _embed_css_Assets_swf_MenuBranchDisabled_793004071:Class = _MenuStyle__embed_css_Assets_swf_MenuBranchDisabled_793004071;
      
      public function _MenuStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("Menu");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("Menu",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.radioIcon = _embed_css_Assets_swf_MenuRadioEnabled_1493941841;
               this.borderStyle = "menuBorder";
               this.paddingTop = 1;
               this.rightIconGap = 15;
               this.branchIcon = _embed_css_Assets_swf_MenuBranchEnabled_1304847660;
               this.checkDisabledIcon = _embed_css_Assets_swf_MenuCheckDisabled_963333585;
               this.verticalAlign = "middle";
               this.paddingLeft = 1;
               this.paddingRight = 0;
               this.checkIcon = _embed_css_Assets_swf_MenuCheckEnabled_620306124;
               this.radioDisabledIcon = _embed_css_Assets_swf_MenuRadioDisabled_79943404;
               this.dropShadowEnabled = true;
               this.branchDisabledIcon = _embed_css_Assets_swf_MenuBranchDisabled_793004071;
               this.dropIndicatorSkin = ListDropIndicator;
               this.separatorSkin = _embed_css_Assets_swf_MenuSeparator_1504191214;
               this.horizontalGap = 6;
               this.leftIconGap = 18;
               this.paddingBottom = 1;
            };
         }
      }
   }
}

