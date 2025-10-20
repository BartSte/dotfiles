// ==UserScript==
// @name         redirect_google_image
// @namespace    http://tampermonkey.net/
// @version      1.0
// @description  Redirect Google Image Search to Google Home. This can be done by detecting `tbm=isch` or `udm=2` in the URL of google.
// @author       You
// @match        *://www.google.com/*tbm=isch*
// @match        *://www.google.com/*udm=2*
// @run-at       document-start
// ==/UserScript==

// Redirect to Google home or a blank page
window.location.href = "https://www.google.com/";
