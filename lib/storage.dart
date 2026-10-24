import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class PlannerStorage {
  static const _stateKey = 'dayboard.state.v1';
  static const _themeKey = 'dayboard.appTheme.v1';
  Future<PlannerState> load() async { final prefs = await SharedPreferences.getInstance(); final raw = prefs.getString(_stateKey); if (raw == null || raw.isEmpty) return PlannerState(); try { return PlannerState.decode(raw); } catch (_) { return PlannerState(); } }
  Future<void> save(PlannerState state) async { final prefs = await SharedPreferences.getInstance(); await prefs.setString(_stateKey, state.encode()); }
  Future<DayTheme> loadTheme() async { final prefs = await SharedPreferences.getInstance(); return DayThemeValue.fromValue(prefs.getString(_themeKey)); }
  Future<void> saveTheme(DayTheme theme) async { final prefs = await SharedPreferences.getInstance(); await prefs.setString(_themeKey, theme.value); }
}
