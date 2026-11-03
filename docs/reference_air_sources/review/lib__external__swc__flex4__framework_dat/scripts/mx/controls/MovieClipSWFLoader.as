package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import mx.core.MovieClipLoaderAsset;
   import mx.core.mx_internal;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   public class MovieClipSWFLoader extends SWFLoader
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public var autoStop:Boolean = true;
      
      public function MovieClipSWFLoader()
      {
         super();
      }
      
      public function get movieClip() : MovieClip
      {
         var content:DisplayObject = this.content;
         if(content is MovieClipLoaderAsset)
         {
            if(DisplayObjectContainer(content).numChildren > 0)
            {
               content = Loader(DisplayObjectContainer(content).getChildAt(0)).content;
            }
         }
         if(content is MovieClip && !(content is ISystemManager))
         {
            return MovieClip(content);
         }
         return null;
      }
      
      public function play() : void
      {
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            movieClip.play();
         }
      }
      
      public function stop() : void
      {
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            movieClip.stop();
         }
      }
      
      public function gotoAndPlay(frame:Object, scene:String = null) : void
      {
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            movieClip.gotoAndPlay(frame,scene);
         }
      }
      
      public function gotoFirstFrameAndStop() : void
      {
         var scenes:Array = null;
         var sceneHasName:Boolean = false;
         var scene:String = null;
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            scenes = movieClip.scenes;
            sceneHasName = Boolean(scenes) && scenes.length > 0 && scenes[0].name != "";
            scene = sceneHasName ? scenes[0].name : null;
            movieClip.gotoAndStop(0,scene);
         }
      }
      
      public function gotoAndStop(frame:Object, scene:String = null) : void
      {
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            movieClip.gotoAndStop(frame,scene);
         }
      }
      
      public function nextFrame() : void
      {
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            movieClip.nextFrame();
         }
      }
      
      public function nextScene() : void
      {
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            movieClip.nextScene();
         }
      }
      
      public function prevFrame() : void
      {
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            movieClip.prevFrame();
         }
      }
      
      public function prevScene() : void
      {
         var movieClip:MovieClip = this.movieClip;
         if(Boolean(movieClip))
         {
            movieClip.prevScene();
         }
      }
      
      override protected function contentLoaded() : void
      {
         var childContent:DisplayObject = null;
         super.contentLoaded();
         if(this.autoStop)
         {
            this.stop();
         }
         if(content is MovieClipLoaderAsset)
         {
            if(DisplayObjectContainer(content).numChildren > 0)
            {
               childContent = DisplayObjectContainer(content).getChildAt(0);
               if(childContent is Loader && Loader(childContent).content == null)
               {
                  content.addEventListener(Event.ADDED,this.content_addedHandler,false,0,true);
               }
            }
         }
      }
      
      private function content_addedHandler(event:Event) : void
      {
         if(this.autoStop)
         {
            this.stop();
         }
         content.removeEventListener(Event.ADDED,this.content_addedHandler);
      }
   }
}

