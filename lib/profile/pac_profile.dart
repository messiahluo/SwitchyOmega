part of switchy_profile;

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

/**
 * A PAC profile selects the proxy by running a [pacScript].
 * If [pacUrl] is not null, the script is downloaded from [pacUrl].
 */
class PacProfile extends ScriptProfile {
  String get profileType => 'PacProfile';

  String _pacUrl;
  String get pacUrl => _pacUrl;
  void set pacUrl(String value) {
    if (value != null && value != '' && value != _pacUrl) {
      pacScript = "";
    }
    _pacUrl = value;
  }

  String pacScript;

  String toScript() => this.pacScript;

  /**
   * Write a wrapper function around the [pacScript].
   */
  void writeTo(CodeWriter w) {
    w.code('function (url, host) {');

    w.newLine().raw(this.pacScript).newLine();

    w.code('return FindProxyForURL(url, host);');
    w.inline('}');
  }

  Map<String, Object> toPlain([Map<String, Object> p]) {
    p = super.toPlain(p);

    if (pacUrl != null) {
      p['pacUrl'] = this.pacUrl;
    } else {
      p['pacScript'] = this.pacScript;
    }

    return p;
  }

  PacProfile(String name) : super(name);

  void loadPlain(Map<String, Object> p) {
    super.loadPlain(p);
    var u = p['pacUrl'];
    if (u != null) {
      this.pacUrl = u;
    }
    this.pacScript = p['pacScript'];
  }

  factory PacProfile.fromPlain(Map<String, Object> p) {
    if (p['profileType'] == 'AutoDectProfile') {
      return new AutoDetectProfile.fromPlain(p);
    }
    var f = new PacProfile(p['name']);
    f.loadPlain(p);
    return f;
  }
}
