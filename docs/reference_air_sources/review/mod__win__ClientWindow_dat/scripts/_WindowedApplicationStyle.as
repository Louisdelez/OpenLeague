package
{
   import mx.core.IFlexModuleFactory;
   import mx.skins.halo.ApplicationTitleBarBackgroundSkin;
   import mx.skins.halo.StatusBarBackgroundSkin;
   import mx.skins.halo.WindowBackground;
   import mx.skins.halo.WindowCloseButtonSkin;
   import mx.skins.halo.WindowMaximizeButtonSkin;
   import mx.skins.halo.WindowMinimizeButtonSkin;
   import mx.skins.halo.WindowRestoreButtonSkin;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _WindowedApplicationStyle
   {
      
      public function _WindowedApplicationStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration("WindowedApplication");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration("WindowedApplication",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.statusTextStyleName = "statusTextStyle";
               this.borderStyle = "solid";
               this.closeButtonSkin = WindowCloseButtonSkin;
               this.buttonAlignment = "auto";
               this.restoreButtonSkin = WindowRestoreButtonSkin;
               this.borderColor = 10921638;
               this.titleTextStyleName = "titleTextStyle";
               this.backgroundColor = 12632256;
               this.statusBarBackgroundSkin = StatusBarBackgroundSkin;
               this.cornerRadius = 8;
               this.backgroundImage = WindowBackground;
               this.gripperPadding = 3;
               this.titleBarBackgroundSkin = ApplicationTitleBarBackgroundSkin;
               this.titleBarColors = [16777215,12237498];
               this.titleBarButtonPadding = 5;
               this.showFlexChrome = true;
               this.roundedBottomCorners = false;
               this.minimizeButtonSkin = WindowMinimizeButtonSkin;
               this.statusBarBackgroundColor = 13421772;
               this.maximizeButtonSkin = WindowMaximizeButtonSkin;
               this.buttonPadding = 2;
               this.borderThickness = 1;
               this.highlightAlphas = [1,1];
               this.titleAlignment = "auto";
               this.gripperStyleName = "gripperSkin";
            };
         }
      }
   }
}

