'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "31b418da4c23be73d0e5cef109e3ed74",
"assets/AssetManifest.bin.json": "2a9c9d02d80b01c671b0c58d137f07cf",
"assets/AssetManifest.json": "d018df9ec999707b41fec8c9cfdcb37e",
"assets/assets/fonts/ibm_bold.ttf": "2f1bf48f9ab5e7f3636ed99dfdd50dd6",
"assets/assets/fonts/ibm_light.ttf": "3f86f97f1ea30329d567250428ee4030",
"assets/assets/fonts/ibm_regular.ttf": "381623977503164534dfd3b90b67c732",
"assets/assets/fonts/Roboto-Black.ttf": "dc44e38f98466ebcd6c013be9016fa1f",
"assets/assets/fonts/Roboto-Bold.ttf": "dd5415b95e675853c6ccdceba7324ce7",
"assets/assets/fonts/Roboto-ExtraBold.ttf": "27fd63e58793434ce14a41e30176a4de",
"assets/assets/fonts/Roboto-Light.ttf": "25e374a16a818685911e36bee59a6ee4",
"assets/assets/fonts/Roboto-Medium.ttf": "7d752fb726f5ece291e2e522fcecf86d",
"assets/assets/fonts/Roboto-Regular.ttf": "303c6d9e16168364d3bc5b7f766cfff4",
"assets/assets/fonts/Roboto-SemiBold.ttf": "dae3c6eddbf79c41f922e4809ca9d09c",
"assets/assets/fonts/Roboto-Thin.ttf": "1e6f2d32ab9876b49936181f9c0b8725",
"assets/assets/icons/arrow_down.svg": "bac2f1f7c7a32349137d2627b96ca9cd",
"assets/assets/icons/attach_files.svg": "0d8cc55d3333c76678d0c6f22871cc67",
"assets/assets/icons/back.svg": "59eadfd427302ff4ba402af4bd92475a",
"assets/assets/icons/calendar_tick.svg": "881943c44e001d1d2ddf2a1ccb32683f",
"assets/assets/icons/converte.svg": "e6d4166e8a6975b623bd13e779b6e61e",
"assets/assets/icons/delete.svg": "67d553bf6c5fe80d2a4341abcc554719",
"assets/assets/icons/document_download.svg": "a41c5885d5361e4f28f18e40cd4a3d92",
"assets/assets/icons/dollar_circle.svg": "16941421e8559a5269877bf000e5cf1d",
"assets/assets/icons/edit.svg": "e1fab8a915ce856d6d8ff1b2bd7b63ce",
"assets/assets/icons/filter_search.svg": "dec2ca49b8e32f448f450d8d3278e7b2",
"assets/assets/icons/money_recive.svg": "87b8e4faec01836ae1fd5746e81bb56d",
"assets/assets/icons/money_send.svg": "24570e74a4f5d9fbda7a0e22589eae62",
"assets/assets/icons/notification.svg": "d2f5d77bdba1f1afe54992a23a8ac3a1",
"assets/assets/icons/plus.svg": "eb7a16c20bfc9c1ad0d6bfbc9d8675b0",
"assets/assets/icons/rectangle_empty.svg": "eedef68b8eecac667407f3b629bc4386",
"assets/assets/icons/rectangle_full.svg": "fa90dadd8de5681e088e3c73b283437b",
"assets/assets/icons/search_normal.svg": "3474e9b8e49b7d6310bdad6d6411415b",
"assets/assets/icons/trash.svg": "9a7f303d0cdf9072add9e467f174ce40",
"assets/assets/images/amerca_flag.png": "2b197dded4d76f1583346b75ffa80a5e",
"assets/assets/images/bg.png": "7d9075af116c0128ccfc80817d5a8aa5",
"assets/assets/images/blur.png": "32653f4b2198406c9ace512b26572e7a",
"assets/assets/images/emarate_flag.png": "45edf65d08c3fd30af98c54501d53784",
"assets/assets/images/euro_currency.png": "d74f994292c4799872c5017bfacfaf39",
"assets/assets/images/german_flag.png": "fef115b3d04a805dbbadf611c199e694",
"assets/assets/images/india_flag.png": "dd6333a0ea19e2d75e68002a1f44b294",
"assets/assets/images/ispanya_flag.png": "500bf99c075534a30913b334e4303665",
"assets/assets/images/logo_black.png": "c5192d5d6c973503c81f501dabcb0fe1",
"assets/assets/images/logo_white.png": "6c875f3dec8e308d7865b8d51c06adcb",
"assets/assets/images/russian_flag.png": "8e1ae66c4cbf6dd6372c8db376e033a2",
"assets/assets/images/uea_currency.png": "f9293083b9094fd6a49ef5436ffd5226",
"assets/assets/images/usa_currency.png": "d73686e66a86272948a8a9203bcb9b97",
"assets/assets/translations/ar.json": "e050608ba194d94100461145d96fc75c",
"assets/assets/translations/de.json": "31b834766a4b14f1249711491b584eed",
"assets/assets/translations/en.json": "479e07045d54b4f15d8b432e883ca897",
"assets/assets/translations/es.json": "985356f126ad0f510e6aa6a5a7fed950",
"assets/assets/translations/hi.json": "0acbe47b97c78d0d57c3958b110bc17d",
"assets/assets/translations/ru.json": "9df573a3064f86e8a6028f3044b831d6",
"assets/FontManifest.json": "9bea62d1c7bdfc7dcc33b276ead6b974",
"assets/fonts/MaterialIcons-Regular.otf": "0f10c0eabf1336d712c7de5744ddb724",
"assets/NOTICES": "59f6ec835e41e3bfd358c4bd3d423dd6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"favicon.png": "6c875f3dec8e308d7865b8d51c06adcb",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"flutter_bootstrap.js": "e66a32f359ef35a586bcc2ee39cfeb7e",
"icons/Icon-192.png": "6c875f3dec8e308d7865b8d51c06adcb",
"icons/Icon-512.png": "6c875f3dec8e308d7865b8d51c06adcb",
"icons/Icon-maskable-192.png": "6c875f3dec8e308d7865b8d51c06adcb",
"icons/Icon-maskable-512.png": "6c875f3dec8e308d7865b8d51c06adcb",
"index.html": "13726ee7df8fb65c4f5e027e83ca334c",
"/": "13726ee7df8fb65c4f5e027e83ca334c",
"main.dart.js": "4c5e34673ad15568187258ae3ddb6216",
"manifest.json": "5480f99bfb1601b07b3e2dc31e06e192",
"vercel.json": "0bbf6d58d9d486df79765ae90d2e39dd",
"version.json": "38a709a6e9845089b727a084c6409616"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
