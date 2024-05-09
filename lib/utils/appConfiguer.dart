//// shopify configureation
class AppConfigure {
  static const appName = "MobJ";
  static const primaryColor = "#0000FF";
  static const secondaryColor = "#ADD8E6";
  static const logoImagePath =
      "https://www.creativefabrica.com/wp-content/uploads/2019/03/Monogram-PY-Logo-Design-by-Greenlines-Studios-580x386.jpg";
  static const loginbackimage =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZgiQwmsQRG7ghIW01bAZaTUGP5NLYyOL0EYIaOZCNYA&s";
  // static const baseUrl =
  //     bigCommerce == true ? bigcommerceUrl : "https://b8507f-9a.myshopify.com/";

  static const baseUrl = bigCommerce
      ? bigcommerceUrl
      : (wooCommerce ? woocommerceUrl : "https://pyvaidyass.myshopify.com/");

  static const tawkURL =
      "https://tawk.to/chat/64917d1494cf5d49dc5ec746/1h3c51695";
  static const aboutApp =
      "Download our laundry app now and we’ll collect, clean and deliver from your home or office. Placing your order via Laundrapp couldn’t be easier – we’ve developed it with ease of use in mind. The award-winning app relaunched in September ‘20 with a fresh new design and improved performance. Take us for a spin:";
  static const paymentGateway = "razorpay";
  static const apiFramework = "shopify";
  static const razorPayId = "rzp_test_qPzk0NCwNZfI8n";
  static const razorPaySecreteKey = "Fnm4HkgeG9zOyhYvVI1kofI6";
  static const accessToken = "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";
  static const storeFrontToken = "ef033d139cdcfff43a487d7cc5fde437";
  static const environment = "SANDBOX";
  static const appId = "";
  static const merchantId = "PGTESTPAYUAT";
  static const saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  static const saltIndex = "1";
  static const callbackUrl =
      "https://webhook.site/f63d1195-f001-474d-acaa-f7bc4f3b20b1";
  static const apiEndPoint = "/pg/v1/pay";
  //fera rating key of shoppify
  static const feraUrl = "https://api.fera.ai/v3/private/";
  static const feraSecretKey =
      "sk_c836fc6ec10cf04f52e45906d988fb62fad9d0d361f3bfda8a13408761e22d77";
  static const pickUpAddressLongitude = 73.841940;
  static const pickUpAddressLatitude = 18.516040;

  ////bigcommerce urls
  static const bigCommerce = true;

  static const bigcommerceUrl =
      'https://api.bigcommerce.com/stores/zwpg4jmenh/v3';
  static const storeFront = 'zwpg4jmenh';
  static const bigCommerceAccessToken = '78m433mgo5za5sdsgnvcjpbrsboac63';

// woo commerce url
// woo commerce url

  static const wooCommerce = false;
  static const woocommerceUrl = 'https://ttf.setoo.org/';

  static const consumerkey = 'ck_db1d729eb2978c28ae46451d36c1ca02da112cb3';
  static const consumersecret = 'cs_c5cc06675e8ffa375b084acd40987fec142ec8cf';
}
