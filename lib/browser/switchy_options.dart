part of switchy_browser;


abstract class SwitchyOptions extends Plainable {
  bool get confirmDeletion;
  void set confirmDeletion(bool value);

  bool get refreshOnProfileChange;
  void set refreshOnProfileChange(bool value);

  String get startupProfileName;
  void set startupProfileName(String value);

  bool get enableQuickSwitch;
  void set enableQuickSwitch(bool value);

  bool get revertProxyChanges;
  void set revertProxyChanges(bool value);

  List<String> get quickSwitchProfiles;

  ProfileCollection _profiles;
  ProfileCollection get profiles => _profiles;

  Profile getProfileByName(String name) {
    return profiles[name];
  }

  String get currentProfileName;
  set currentProfileName(String value);

  Object toPlain([Map<String, Object> p]) {
    if (p == null) p = new Map<String, Object>();
    p['confirmDeletion'] = confirmDeletion;
    p['refreshOnProfileChange'] = refreshOnProfileChange;
    p['startupProfileName'] = startupProfileName;
    p['enableQuickSwitch'] = enableQuickSwitch;
    p['revertProxyChanges'] = revertProxyChanges;

    p['quickSwitchProfiles'] = quickSwitchProfiles;

    var plainProfiles = new Map<String, Object>();
    profiles.forEach((p) {
      plainProfiles[p.name] = p.toPlain();
    });

    p['profiles'] = profiles.toPlain();

    p['currentProfileName'] = currentProfileName;

    return p;
  }

  void loadPlain(Map<String, Object> p) {
    currentProfileName = p['currentProfileName'];
    confirmDeletion = p['confirmDeletion'];
    refreshOnProfileChange = p['refreshOnProfileChange'];
    startupProfileName = p['startupProfileName'];
    enableQuickSwitch = p['enableQuickSwitch'];
    revertProxyChanges = p['revertProxyChanges'];

    quickSwitchProfiles.clear();
    quickSwitchProfiles.addAll(p['quickSwitchProfiles']);

    _profiles = new ProfileCollection.fromPlain(p['profiles']);

    currentProfileName = p['currentProfileName'];
  }

  SwitchyOptions();

  SwitchyOptions.fromPlain(Object p) {
    this.loadPlain(p);
  }

  SwitchyOptions.defaults() {
    confirmDeletion = true;
    refreshOnProfileChange = true;
    startupProfileName = '';
    enableQuickSwitch = false;
    revertProxyChanges = false;

    quickSwitchProfiles.clear();
    _profiles = new ProfileCollection();
  }

}