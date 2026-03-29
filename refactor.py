import re

path = 'F:/sign_language_app/lib/screens/auth/login_screen.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Remove _selectedRole variable
content = re.sub(r"  String _selectedRole = 'student';\s*", "", content)

# 2. Remove role selector UI
content = re.sub(r'                  // Role selector.*?const SizedBox\(height: 24\);', '', content, flags=re.DOTALL)

# 3. Remove _roleTab method
content = re.sub(r'  Widget _roleTab.*?return Expanded.*?\s+}\n', '', content, flags=re.DOTALL)

# 4. Remove auth.setRole(_selectedRole);
content = re.sub(r'      auth.setRole\(_selectedRole\);\s*', '', content)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
print('Done!')
