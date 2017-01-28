package {

  import flash.events.EventDispatcher;


  public class TwitterController extends EventDispatcher {
    static public const BUSINESS_KEY: String = "1234567890"
    static public const INNEBULA_SECRET: String = "qwertyQWERTY1234567890asdfASDFzxcvZXCV";

    protected var _twitauth: OAuthManager = new OAuthManager();


    public function TwitterController() {
      _twitauth.addEventListener(OAuthEvent.ON_REQUEST_TOKEN_RECEIVED, onRequestTokenReceived);
      _twitauth.addEventListener(OAuthEvent.ON_REQUEST_TOKEN_FAILED, onRequestTokenFailed);
      _twitauth.addEventListener(OAuthEvent.ON_ACCESS_TOKEN_RECEIVED, onAccessTokenReceived);
      _twitauth.addEventListener(OAuthEvent.ON_ACCESS_TOKEN_FAILED, onAccessTokenFailed);
      _twitauth.usePinWorkflow = true;
    }

    public function run(): void {
      _twitauth.consumerKey = INNEBULA_KEY;
      _twitauth.consumerSecret = INNEBULA_SECRET;
      _twitauth.oauthDomain = "twitter.com";
      _twitauth.requestToken();
    }

    public function applyPin(pin: String): void {
      _twitauth.requestAccessToken(Number(pin));
    }

    protected function onAccessTokenFailed(event: OAuthEvent): void {

    }

    protected function onAccessTokenReceived(event: OAuthEvent): void {
      var customerName: String = _twitauth.currentUserName;
      dispatchEvent(new SocialAuthorizingEvent(SocialAuthorizingEvent.REQUEST_ACCEPTED,
        {
          username: _twitauth.currentUserName,
          access_id: _twitauth.accessPin,
          access_token: _twitauth.accessToken,
          access_secret: _twitauth.accessTokenSecret
        }));
    }

    protected function onRequestTokenFailed(event: OAuthEvent): void {

    }

    protected function onRequestTokenReceived(event: OAuthEvent): void {
      _twitauth.requestAuthorisation();
      dispatchEvent(new SocialAuthorizingEvent(SocialAuthorizingEvent.REQUEST_SENT));
    }
  }
}
