// Single source of truth for the API base URL.
//
// 10.0.2.2 is the Android emulator's special alias for the host
// machine's localhost. Swap this constant when testing on a
// physical phone (use your PC's LAN IP, e.g. 192.168.x.x) or when
// later migrating to online hosting.
//
// Change ONLY this value when switching environments.
const String kApiBaseUrl = 'http://localhost:8081/api';
// const String kApiBaseUrl = 'http://10.0.2.2:8081/api';
