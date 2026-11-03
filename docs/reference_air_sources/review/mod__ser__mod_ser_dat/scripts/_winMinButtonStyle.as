package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _winMinButtonStyle
   {
      
      private static var _embed_css_win_min_over_png_184635300:Class = _winMinButtonStyle__embed_css_win_min_over_png_184635300;
      
      private static var _embed_css_win_min_dis_png_287786772:Class = _winMinButtonStyle__embed_css_win_min_dis_png_287786772;
      
      private static var _embed_css_win_min_down_png_2074636176:Class = _winMinButtonStyle__embed_css_win_min_down_png_2074636176;
      
      private static var _embed_css_win_min_up_png_190296726:Class = _winMinButtonStyle__embed_css_win_min_up_png_190296726;
      
      public function _winMinButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".winMinButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".winMinButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.upSkin = _embed_css_win_min_up_png_190296726;
               this.downSkin = _embed_css_win_min_down_png_2074636176;
               this.overSkin = _embed_css_win_min_over_png_184635300;
               this.disabledSkin = _embed_css_win_min_dis_png_287786772;
            };
         }
      }
   }
}

