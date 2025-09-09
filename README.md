# GPS出租车数据API - V0前端专用

## 🌐 项目概述
这是一个专为V0前端设计的GPS出租车数据API服务，部署在GitHub Pages上，提供公网可访问的静态数据接口。

## 📊 数据集描述
- **数据来源**: 济南市出租车GPS轨迹数据
- **时间范围**: 2013年9月12日-18日 (7天)
- **数据规模**: ~14万个采样GPS轨迹点
- **坐标系统**: WGS84 (经纬度)
- **文件大小**: 约7.3MB

## 🔗 API端点

### 基础信息接口
- `GET /api/index.json` - API信息和端点列表
- `GET /api/dates.json` - 可用日期列表
- `GET /api/summary.json` - 数据集摘要统计

### 数据接口  
- `GET /data/taxi_data_YYYY-MM-DD.json` - 指定日期的轨迹数据
- `GET /data/taxi_summary_by_hour.json` - 按小时汇总的统计数据

### V0前端专用
- `GET /v0-config.json` - V0前端配置文件

## 📋 数据格式

### 轨迹点数据格式
```json
{
  "date": "2013-09-12",
  "columns": ["lng", "lat", "timestamp", "flag"],
  "total": 100000,
  "sampled": 20000,
  "points": [
    [117.060662, 36.687573, 1378915201, 1],
    [117.048245, 36.680194, 1378915231, 0]
  ]
}
```

### 字段说明
- `lng`: 经度 (WGS84)
- `lat`: 纬度 (WGS84) 
- `timestamp`: Unix时间戳 (秒)
- `flag`: 载客状态 (0=空车, 1=载客)

## 🚀 V0前端集成

### 步骤1: 配置API基础URL
```javascript
// 替换为你的GitHub Pages地址
const API_BASE_URL = 'https://YOUR-USERNAME.github.io/YOUR-REPO-NAME';
```

### 步骤2: React/Next.js集成示例
```jsx
import { useState, useEffect } from 'react';

const API_BASE_URL = 'https://YOUR-USERNAME.github.io/YOUR-REPO-NAME';

function GPSDataViewer({ selectedDate = '2013-09-12' }) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    const fetchGPSData = async () => {
      try {
        setLoading(true);
        const response = await fetch(`${API_BASE_URL}/data/taxi_data_${selectedDate}.json`);
        
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }
        
        const gpsData = await response.json();
        setData(gpsData);
        setError(null);
      } catch (err) {
        setError(err.message);
        console.error('GPS数据加载失败:', err);
      } finally {
        setLoading(false);
      }
    };
    
    fetchGPSData();
  }, [selectedDate]);
  
  if (loading) return <div>加载GPS数据中...</div>;
  if (error) return <div>加载错误: {error}</div>;
  if (!data) return <div>无数据</div>;
  
  return (
    <div>
      <h2>GPS轨迹数据 - {data.date}</h2>
      <p>轨迹点数: {data.sampled} / {data.total}</p>
      
      {/* 渲染地图组件 */}
      <MapComponent 
        center={[36.65, 117.0]}  // 济南市中心
        zoom={11}
        points={data.points.map(([lng, lat, timestamp, flag]) => ({
          lng,
          lat, 
          timestamp,
          status: flag === 1 ? '载客' : '空车',
          color: flag === 1 ? '#ff0000' : '#808080'  // 红色=载客，灰色=空车
        }))}
      />
    </div>
  );
}

// 获取可用日期的Hook
function useDateList() {
  const [dates, setDates] = useState([]);
  
  useEffect(() => {
    fetch(`${API_BASE_URL}/api/dates.json`)
      .then(res => res.json())
      .then(data => setDates(data.dates))
      .catch(err => console.error('日期列表加载失败:', err));
  }, []);
  
  return dates;
}
```

### 步骤3: 原生JavaScript集成
```javascript
// GPS数据API客户端
class GPSDataClient {
  constructor(baseUrl) {
    this.baseUrl = baseUrl;
    this.cache = new Map();
  }
  
  async fetchWithCache(endpoint) {
    if (this.cache.has(endpoint)) {
      return this.cache.get(endpoint);
    }
    
    const response = await fetch(`${this.baseUrl}${endpoint}`);
    if (!response.ok) {
      throw new Error(`API请求失败: ${response.status}`);
    }
    
    const data = await response.json();
    this.cache.set(endpoint, data);
    return data;
  }
  
  async getTrajectoryData(date) {
    return this.fetchWithCache(`/data/taxi_data_${date}.json`);
  }
  
  async getAvailableDates() {
    return this.fetchWithCache('/api/dates.json');
  }
  
  async getSummary() {
    return this.fetchWithCache('/api/summary.json');
  }
}

// 使用示例
const gpsClient = new GPSDataClient('https://YOUR-USERNAME.github.io/YOUR-REPO-NAME');

// 获取并显示GPS数据
gpsClient.getTrajectoryData('2013-09-12')
  .then(data => {
    console.log(`获得 ${data.sampled} 个轨迹点`);
    
    // 处理轨迹数据
    data.points.forEach(([lng, lat, timestamp, flag]) => {
      // lng: 经度, lat: 纬度, timestamp: 时间戳, flag: 载客状态
      addMapMarker(lng, lat, flag === 1 ? '载客' : '空车');
    });
  })
  .catch(error => {
    console.error('数据获取失败:', error);
  });
```

## 🌍 GitHub Pages部署指南

### 快速部署 (3分钟完成)

#### 1. 创建GitHub仓库
1. 登录 [GitHub.com](https://github.com)
2. 点击右上角 "+" → "New repository"
3. 仓库名称: `taxi-gps-api` (可自定义)
4. 设置为 **Public** (GitHub Pages免费版要求)
5. 勾选 "Add a README file" 
6. 点击 "Create repository"

#### 2. 上传API数据文件
**方法A: Web界面上传**
1. 在新创建的仓库页面，点击 "uploading an existing file"
2. 将本目录下的所有文件拖拽上传:
   - `README.md`, `_headers`, `v0-config.json`
   - `api/` 文件夹 (包含dates.json, index.json, summary.json)
   - `data/` 文件夹 (包含所有taxi_data_*.json文件)
3. 提交信息: "初始化GPS数据API"
4. 点击 "Commit changes"

**方法B: Git命令行**
```bash
# 克隆你的仓库
git clone https://github.com/YOUR-USERNAME/taxi-gps-api.git
cd taxi-gps-api

# 复制所有API文件
cp -r /path/to/backend/github_pages/* ./

# 提交和推送
git add .
git commit -m "部署GPS数据API到GitHub Pages"
git push origin main
```

#### 3. 启用GitHub Pages
1. 进入仓库页面 → Settings
2. 侧边栏找到 "Pages" 选项
3. Source 选择 "Deploy from a branch"
4. Branch 选择 "main" (或 "master")
5. Folder 保持 "/ (root)"
6. 点击 "Save"

#### 4. 等待部署完成
- 通常需要 1-5 分钟
- 页面顶部会显示部署状态
- 绿色勾号 = 部署成功
- 你的API地址: `https://YOUR-USERNAME.github.io/taxi-gps-api/`

### 部署验证

部署完成后，测试以下API端点：

```bash
# 替换YOUR-USERNAME为你的GitHub用户名
curl https://YOUR-USERNAME.github.io/taxi-gps-api/api/dates.json
curl https://YOUR-USERNAME.github.io/taxi-gps-api/api/summary.json
curl https://YOUR-USERNAME.github.io/taxi-gps-api/data/taxi_data_2013-09-12.json
```

或在浏览器中访问:
- https://YOUR-USERNAME.github.io/taxi-gps-api/api/dates.json
- https://YOUR-USERNAME.github.io/taxi-gps-api/data/taxi_data_2013-09-12.json

### V0前端配置

部署成功后，在V0前端项目中更新API配置：

```javascript
// 替换为你的实际GitHub Pages地址
const API_BASE_URL = 'https://YOUR-USERNAME.github.io/taxi-gps-api';

// 测试API连接
fetch(`${API_BASE_URL}/api/dates.json`)
  .then(res => res.json())
  .then(data => console.log('✅ API连接成功:', data.dates))
  .catch(err => console.error('❌ API连接失败:', err));
```

## 🔧 故障排除

### 常见问题
1. **404 Not Found**
   - 确认文件已正确上传到仓库根目录
   - 等待GitHub Pages部署完成(绿色勾号)
   - 检查文件路径大小写

2. **仓库未显示GitHub Pages选项**
   - 确认仓库设置为Public
   - 确认仓库包含至少一个文件

3. **CORS错误**
   - GitHub Pages天然支持CORS
   - 确认请求URL完整正确
   - 尝试在浏览器隐私模式测试

4. **数据更新不生效**
   - GitHub Pages有CDN缓存，更新可能需要几分钟
   - 尝试在URL后加 `?v=timestamp` 强制刷新

### 性能优化
- GitHub Pages提供全球CDN，访问速度很快
- 数据文件已优化，每个JSON文件约1MB
- 建议V0前端实现缓存机制减少重复请求

## 📈 使用统计
- **免费额度**: 每月100GB带宽流量
- **响应速度**: 全球CDN < 200ms
- **可用性**: 99.9%+ SLA保证  
- **SSL支持**: 自动HTTPS加密
