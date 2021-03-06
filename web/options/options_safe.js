/*!
 * Copyright (C) 2012, The SwitchyOmega Authors. Please see the AUTHORS file
 * for details.
 *
 * This file is part of SwitchyOmega.
 *
 * SwitchyOmega is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SwitchyOmega is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with SwitchyOmega.  If not, see <http://www.gnu.org/licenses/>.
 */

'use strict';
var i18nCache = {};
strings.forEach(function (name) {
  i18nCache[name] = chrome.i18n.getMessage(name);
});

// Set the title
document.title = i18nCache['options_title'];

var c = new Communicator();

c.on({
  'tab.get': function (_, respond) {
    var hash;
    if (location.hash) {
      hash = location.hash;
      location.hash = '';
    } else {
      hash = localStorage['options_last_tab'];
    }
    respond(hash);
  },
  'tab.set': function (hash, respond) {
    localStorage['options_last_tab'] = hash;
    respond();
  },
  'i18n.get': function (data, respond) {
    respond(chrome.i18n.getMessage(data.name, data.substs));
  },
  'i18n.cache': function (data, respond) {
    respond(i18nCache);
  },
  'options.get': function (data, respond) {
  	respond({'tab': localStorage['options_last_tab'], 'options': {
  	  // The profiles are from the pac_gen_test.
  	  'confirmDeletion': true,
  	  'profiles': [
  	      {
  	        "name":"ssh",
  	        "bypassList":[
  	          {"pattern":"127.0.0.1:3333","conditionType":"BypassCondition"},
  	          {"pattern":"https://www.example.com","conditionType":"BypassCondition"},
  	          {"pattern":"*:3333","conditionType":"BypassCondition"},
  	          {"pattern":"<local>","conditionType":"BypassCondition"}
  	        ],
  	        "profileType":"FixedProfile",
  	        "color":"#0000cc",
  	        "proxyForHttp":{"scheme":"http","port":8080,"host":"127.0.0.1"},
  	        "fallbackProxy":{"scheme":"socks5","port":7070,"host":"127.0.0.1"}
  	      },
  	      {
  	        "name":"http",
  	        "color":"#0000cc",
  	        "fallbackProxy":{"scheme":"http","port":8888,"host":"127.0.0.1"},
  	        "bypassList":[],
  	        "profileType":"FixedProfile"
  	      },
  	      {
  	        "name":"auto",
  	        "color":"#0000cc",
  	        "defaultProfileName":"http",
  	        "rules": [
  	          {"profileName":"ssh","condition":{"pattern":"*.example.com","conditionType":"HostWildcardCondition"}},
  	          {"profileName":"direct","condition":{"minValue":0,"conditionType":"HostLevelsCondition","maxValue":0}},
  	          {"profileName":"ssh","condition":{"pattern":"foo","conditionType":"KeywordCondition"}}
  	        ],
  	        "profileType":"SwitchProfile"
  	      }
  	    ],
  	  'quickSwitchProfiles' : []
  	}});
  }
});

document.addEventListener('DOMContentLoaded', function () {
  c.dest = document.getElementsByTagName('iframe')[0].contentWindow;
}, false);